use warnings;
use 5.010;
use strict;
use lib 'lib';
use Quelology::Config qw/schema dbh/;
use List::MoreUtils qw/uniq/;
$ENV{QUELOLOGY_RUNMODE} = 'dev';
my $qd = schema();
my $qt = do {
    # since schema() is memoized, we need to trick it
    # ... that's an ugly hack, don't try to do that at home!
    Quelology::Model->connect(
        sub {
            local $ENV{QUELOLOGY_RUNMODE} = 'test';
            dbh();
        }
    )
};

sub uniq_by_id {
    my %h;
    my @ret;
    for (@_) {
        push @ret, $_ unless $h{$_->id}++;
    }
    @ret;
}

my @series_ids = qw/35263 17602/;
my @singles = qw/62011 74299/;
my @titles = ($qd->t->search({ id => \@singles }),
             map $_->whole_tree, $qd->t->search({ id => \@series_ids}));
say scalar @titles;
my @translations = map $_->translations, @titles;
my @all_titles = (@titles, @translations);
say scalar @all_titles;
my @authors = uniq_by_id map $_->authors, @all_titles;
my @publications = map $_->publications->search(undef, { prefetch => 'publisher' }), @all_titles;
my @publishers = uniq_by_id map $_->publisher, @publications;
my @author_title = uniq_by_id map $_->author_titles, @all_titles;
say @all_titles + @authors + @publications + @publishers + @author_title;

my %import = (
    Title       => \@all_titles,
    Author      => \@authors,
    Publication => \@publications,
    Publisher   => \@publishers,
    AuthorTitle => \@author_title,
);

# order is important here, I fear
for (qw/Publisher Author Title Publication AuthorTitle/) {
    do_import($_, $import{$_});
}

use Data::Dumper;

sub do_import {
    my ($rs_name, $rows) = @_;
    say "Importing $rs_name";
    say join ', ', map $_->id, @$rows;
    my $destination = $qt->resultset($rs_name);
    for (@$rows) {
        my $h = {$_->get_columns};
#        print Dumper $h;
        $destination->create({$_->get_columns});
    }
}
