use warnings;
use 5.012;
use lib 'lib';
use Quelology::Config qw/schema/;
binmode STDOUT, ':encoding(UTF-8)';

my $schema = schema;
my $titles = $schema->t->with_different_languages;

while (my $t = $titles->next) {
    say $t->title;
    my @nt = $t->split_by_language;
    say '    ', $_->lang, ' ', $_->title for @nt;
}
