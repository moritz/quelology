use warnings;
use 5.010;
use strict;
use lib 'lib';
use Quelology::Config qw/schema amazon/;
use Quelology::XISBNImport qw/from_isbn/;
use List::MoreUtils qw/uniq/;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

my $rs = schema->t->with_translations->search(undef, { rows => 50 });
while (my $t = $rs->next) {
    my $isbn = $t->publications->first->isbn;
    my $xisbn_data = from_isbn($isbn);
    my @isbns = keys %{ $xisbn_data };
    my @orig_lang = uniq grep $_, map $xisbn_data->{$_}{originalLang}, @isbns;
    if (@orig_lang == 1) {
        if ($t->lang ne $orig_lang[0]) {
            say $t->lang, ' ', $t->title;
            say "    found a title with wrong original language";
        }
    } elsif (@orig_lang == 0) {
        next;
    } else {
        say "more than one original language: @orig_lang ($isbn)";
    }
}
