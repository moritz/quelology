use warnings;
use 5.012;
use lib 'lib';
use Quelology::Config qw/schema/;
binmode STDOUT, ':encoding(UTF-8)';

my $schema = schema;
my $titles = $schema->t->singles;

while (my $t = $titles->next) {
    next if $t->author_titles->count;
    next if $t->publications->count;
    say $t->title;
    $t->delete;
}
