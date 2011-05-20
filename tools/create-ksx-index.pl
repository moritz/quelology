use warnings;
use 5.010;
use strict;
use lib 'lib';
use Quelology::Config qw/schema dbh/;
use utf8;
use KinoSearch::Plan::Schema;
use KinoSearch::Plan::FullTextType;
use KinoSearch::Plan::StringType;
use KinoSearch::Analysis::PolyAnalyzer;
use KinoSearch::Index::Indexer;
use File::Path qw/remove_tree/;

use Memoize;
memoize('poly_an');
memoize('fulltext');

my $dbh = dbh();

sub poly_an {
    my $lang = shift;
    KinoSearch::Analysis::PolyAnalyzer->new(language => $lang);
}

sub fulltext {
    my $lang = shift;
    KinoSearch::Plan::FullTextType->new(
        analyzer => poly_an($lang),
        stored   => 0,
    );
}

my $string   = KinoSearch::Plan::StringType->new( stored => 1, sortable => 0);
my $qu = schema();

for my $section (qw(author series title)) {
    my $ks       = KinoSearch::Plan::Schema->new;
    $ks->spec_field(name => 'id',           type => $string  );
    $ks->spec_field(name => 'data',         type => fulltext('en'));
    $ks->spec_field(name => 'series_id',    type => $string  ) if $section eq 'title';



    my $idx_path = "data/search-index/$section";
    remove_tree($idx_path);
    my $indexer  = KinoSearch::Index::Indexer->new(
        schema  => $ks,
        index   => $idx_path,
        create  => 1,
    );

    my %populate = (
        author  => \&index_author,
        title   => \&index_title,
        series  => \&index_series,
    );

    my $before = time;
    my $count = $populate{$section}->($indexer);
    $indexer->optimize();
    $indexer->commit();
    my $time_diff = time - $before;
    printf "Indexed % 6d items in section '%s' in %d seconds\n",
        $count, $section, $time_diff;
}

my $prefetch = { prefetch => { author_titles => 'author' } };

sub index_author {
    my $indexer = shift;
    my $c = 0;
    my $sth = $dbh->prepare('SELECT id, name, legal_name FROM author');
    $sth->execute;
    $sth->bind_columns(\my ($id, $name, $legal_name));

    while ($sth->fetch) {
        no warnings 'uninitialized';
        $indexer->add_doc({
                id      => $id,
                data    => $name . ', ' . $legal_name,
            });
        $c++;
    }
    $c;
}

sub index_series {
    my $indexer = shift;
    my $c = 0;
    my $sth = $dbh->prepare(q[
        SELECT title.id,
               title.title                                         AS rt,
               ARRAY_TO_STRING(ARRAY_AGG(leaf.title       ), ', ') AS lt,
               ARRAY_TO_STRING(ARRAY_AGG(publication.title), ', ') AS pub,
               ARRAY_TO_STRING(ARRAY_AGG(author.name      ), ', ') AS au
          FROM title
          JOIN title leaf ON leaf.root_id = title.id
          JOIN publication ON leaf.id = publication.title_id
          JOIN author_title_map m ON m.title_id = title.id
          JOIN author ON author.id = m.author_id
      GROUP BY title.id, title.title
    ]);
    $sth->execute;
    $sth->bind_columns(\my ($id, $title, $leaf_titles, $pubs, $authors));
    while ($sth->fetch) {
        my $combined     = "$title, $leaf_titles\n\t$authors\n\t$pubs";
        $indexer->add_doc({
                id          => $id,
                data        => $combined,
            });
        $c++;
    }
    $c;
}

sub index_title {
    my $indexer = shift;
    my $c = 0;
    # too slow if done via DBIx::Class, so get down to the metal:
    my $sth = $dbh->prepare(q[
        SELECT title.id,
               title.root_id,
               title.title                                         AS t,
               ARRAY_TO_STRING(ARRAY_AGG(publication.title), ', ') AS pub,
               ARRAY_TO_STRING(ARRAY_AGG(author.name), ', ')       AS au
          FROM title
          JOIN publication ON title.id = publication.title_id
          JOIN author_title_map m ON m.title_id = title.id
          JOIN author ON author.id = m.author_id
      GROUP BY title.id, title.root_id, title.title
    ]);
    $sth->execute;
    $sth->bind_columns(\my ($id, $root_id, $title, $pubs, $authors));


    while ($sth->fetch) {
        my $combined     = "$title\n\t$authors\n\t$pubs";
        $indexer->add_doc({
                id          => $id,
                data        => $combined,
                series_id   => $root_id // '',
            });
        $c++;
    }
    $c;
}
