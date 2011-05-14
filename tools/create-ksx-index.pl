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

my $sortable = KinoSearch::Plan::StringType->new( stored => 1, sortable => 1);
my $string   = KinoSearch::Plan::StringType->new( stored => 1, sortable => 0);

my $ks       = KinoSearch::Plan::Schema->new;
$ks->spec_field(name => 'id',           type => $string  );
$ks->spec_field(name => 'type',         type => $sortable);
$ks->spec_field(name => 'data',         type => fulltext('en'));

my $idx_path = 'data/search-index/common';
my $indexer  = KinoSearch::Index::Indexer->new(
    schema  => $ks,
    index   => $idx_path,
    create  => 1,
);

my $qu = schema();

my $c = 0;
my $authors = $qu->a;
while (my $a = $authors->next) {
    no warnings 'uninitialized';
    $indexer->add_doc({
        id      => $a->id,
        type    => 'author',
        data    => $a->name . '   ' . $a->legal_name,
    });
    $c++;
}


my $titles = $qu->t->root_nodes;
while (my $t = $titles->next) {
    my $type      = $t->is_single ? 'title' : 'series';
    my $search_on = $t->is_single ? $t      : $qu->t->search({ root_id => $t->id });
    my $authors      = join ', ', map { $_->name  } $search_on->authors;
    my $titles       = join ', ', map { $_->title } $search_on->all;
    my $publications = join ', ', map { $_->title, $_->isbn // '' } $search_on->publications;
    my $combined     = "$titles\n\t$authors\n\t$publications";
#    say $combined;
    $indexer->add_doc({
        id      => $t->id,
        type    => $type,
        data    => $combined,
        });
    $c++;
}
$indexer->commit;
say $c, ' titles/series/authors indexed';
