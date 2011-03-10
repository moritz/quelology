use warnings;
use 5.012;
use lib 'lib';
use Quelology::Config qw(schema);

my $schema = schema;

my $rs = $schema->resultset('Medium')->root_nodes;

while (my $node = $rs->next) {
    say $node->title;
    for my $n ($node->descendants) {
        say '   ' x $n->level, $n->title;
    }
}

