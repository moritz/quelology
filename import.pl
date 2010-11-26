use warnings;
use 5.012;
use lib 'lib';
use XFacts::Config qw(schema amazon);

my $schema = schema;
my @asins = (
                # lord of the rings
                qw(0618574948 0618129081 0618574972),
                # demons by Peter V. Brett
                qw(0345518705 0345503813),
                # black magician
                qw(006057528X 0060575298 0060575301),
                # traitor spy trilogy
                qw(0316037834 0316037869),
                # the Hobbit, Silmarillion, unfinished tales
                qw(0261102664 B0017PICLQ 0618154043),
              );

my @objs = map $schema->resultset('Medium')->from_asin($_), @asins;
for (@objs) {
    say $_->title;
}
my %rels = (
'The Lord of the Ring' => [0, 1, 2],
'Demon Series' => [3, 4],
'The Black Magician Trilogy' => [5, 6, 7],
'The Traitor Spy Trilogy' => [8, 9],
);

my %roots;

while (my ($l, $r) = each %rels) {
    say "$l -> $r";
    my $root = $schema->resultset('Medium')->create({
            title => $l,
    });
    $root->attach_rightmost_child($objs[$_]) for @$r;
    $roots{$l} = $root;
}

my $middleearth = $schema->resultset('Medium')
        ->create({ title => 'Middle Earth' });
$middleearth->attach_rightmost_child(@objs[10, 11], $roots{'The Lord of the Ring'}, $objs[12]);

my $rs = $schema->resultset('Medium')->search({
        'id'   =>   \'root_id',
    });
while (my $node = $rs->next) {
    print_recursively($node);
}

sub print_recursively {
    my $n = shift;
    say "  " x $n->level, " ", $n->title;
    for ($n->children) {
        print_recursively $_;
    }
}

