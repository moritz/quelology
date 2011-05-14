use warnings;
use 5.010;
use strict;
use lib 'lib';
use Quelology::Config qw/schema/;
use utf8;
use KinoSearch::Plan::Schema;
use KinoSearch::Plan::FullTextType;
use KinoSearch::Plan::StringType;
use KinoSearch::Analysis::PolyAnalyzer;
use KinoSearch::Index::Indexer;

use Memoize;
memoize('poly_an');
memoize('fulltext');

sub poly_an {
    my $lang = shift;
    KinoSearch::Analysis::PolyAnalyzer->new(language => $lang);
}

sub fulltext {
    my $lang = shift;
    KinoSearch::Plan::FullTextType->new(
        analyzer => poly_an($lang),
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
    $indexer->commit();
    my $time_diff = time - $before;
    say "Indexed $count items in section $section in $time_diff seconds";
}

my $prefetch = { prefetch => { author_titles => 'author' } };

sub index_author {
    my $indexer = shift;
    my $c = 0;
    my $authors = $qu->a;
    while (my $a = $authors->next) {
        no warnings 'uninitialized';
        $indexer->add_doc({
                id      => $a->id,
                data    => $a->name . '   ' . $a->legal_name,
            });
        $c++;
    }
    $c;
}

sub index_series {
    my $indexer = shift;
    my $c = 0;
    my $titles = $qu->t->threads->search(undef, $prefetch);
    while (my $t = $titles->next) {
        my $authors      = join ', ', map { $_->name  } $t->authors;
        my $titles       = join ', ', map { $_->title } $t, $t->descendants;
        my $publications = join ', ', map { $_->title, $_->isbn // '' } $t->publications, $t->descendants->publications;
        my $combined     = "$titles\n\t$authors\n\t$publications";
#    say $combined;
        $indexer->add_doc({
                id          => $t->id,
                data        => $combined,
            });
        $c++;
    }
    $c;
}

sub index_title {
    my $indexer = shift;
    my $c = 0;
    my $titles = $qu->t->singles->search(undef, $prefetch);
    while (my $t = $titles->next) {
        my $authors      = join ', ', map { $_->name  } $t->authors;
        my $publications = join ', ', map { $_->title, $_->isbn // '' } $t->publications, $t->descendants->publications;
        my $combined     = $t->title . "\n\t$authors\n\t$publications";
#    say $combined;
        $indexer->add_doc({
                id          => $t->id,
                data        => $combined,
                series_id   => $t->root_id == $t->id ? '' : $t->root_id,
            });
        $c++;
    }
    $c;
}
