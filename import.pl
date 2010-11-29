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
                # Kushiel's Dart, Chosen, Avatar
                qw(0765342987 0765345048 0765347539),
                # Kushiel's Scion, Justice, Mercy
                qw(044661002X 0446610143 044661016X),
                # Naamah's Kiss, Curse, Blessing
                qw(0446198048 0446198056 0446198072),
    );

my @objs = map $schema->resultset('Medium')->from_asin($_), @asins;
for (@objs) {
    say $_->title;
}
my %rels = (
    'The Lord of the Rings' => [0, 1, 2],
    'Demon Series' => [3, 4],
    'The Black Magician Trilogy' => [5, 6, 7],
    'The Traitor Spy Trilogy' => [8, 9],
    "Kushiel's Dart (Phedre)" => [13, 14, 15],
    "Kushiel's Scion (Imriel)" => [16, 17, 18],
    "Naamah's Gift (Moirin)" => [19, 20, 21],
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
$middleearth->attach_rightmost_child(@objs[11, 10], $roots{'The Lord of the Rings'}, $objs[12]);

# TODO: Add "Magician's Apprentice"
#my $trudi = $schema->resultset('Medium')
#        ->create({ title => '' });
#$trudi->


my $terre_dange = $schema->resultset('Medium')
    ->create({title => "Terre d'Ange"});
$terre_dange
    ->attach_rightmost_child(@roots{ "Kushiel's Dart (Phedre)",
            "Kushiel's Scion (Imriel)", "Naamah's Gift (Moirin)"});

say '';
my $rs = $schema->resultset('Medium')->root_nodes;
$rs->reset;

while (my $node = $rs->next) {
    say $node->title;
    for my $n ($node->descendants) {
        say '   ' x $n->level, $n->title;
    }
}
