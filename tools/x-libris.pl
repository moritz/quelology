use 5.010;
use strict;
use warnings;
use lib 'lib';
binmode STDOUT, ':encoding(UTF-8)';
use Quelology::Config qw/schema/;
use WebService::Libris;
use WebService::Libris::FileCache;
use ISBN::Country qw/isbn_extract/;


my %seen;
my $rs = schema->p->search({ libris_id => { '<>' => undef }, isbn => { '<>' => undef }});
my ($same, $total) = (0, 0);
while (my $pub = $rs->next) {
    next if $seen{$pub->isbn}++;
    my $title = $pub->title;
    my $lp = WebService::Libris->new(
        type    => 'bib',
        id      => $pub->libris_id,
        cache   => WebService::Libris::FileCache->new(
                        directory   => 'data/libris/',
                   ),
    );
    my $authors_ids = join ', ', $lp->authors_ids;
    printf "%s (%s) %s\n", $pub->lang, $pub->isbn, $pub->title;
    my $related_collection = $lp->related_books;
    while (my $related_lp = $related_collection->next) {
        $total++;
        my $ai = join ', ', $related_lp->authors_ids;
        my $lang = $related_lp->language // 'XX';
        $lang = 'XX' if length($lang) != 2;
        my $isbn = $related_lp->isbn;
        next unless $isbn;
        next if $seen{$isbn}++;
        next unless $authors_ids = $ai;
        my $isbn_lang = eval { isbn_extract($isbn)->{lang}[0] } // 'XX';
        say '  ', join '  ',  $lang, $isbn_lang, "(" . $related_lp->id . ")", $related_lp->title;
        $same++;
    }
}

say "$same/$total"
