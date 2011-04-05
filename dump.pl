use warnings;
use 5.012;
use lib 'lib';
use Quelology::Config qw(schema);

my $schema = schema;

my $rs = $schema->resultset('Title')->root_nodes;

while (my $node = $rs->next) {
    say '=' x 40;
    dump_($node);
    for my $n ($node->descendants) {
        dump_($n);
    }
}


sub dump_ {
    my $n = shift;
    say join ':::', $n->id, $n->asin // '', $n->level, $n->title, $n->author;
}
