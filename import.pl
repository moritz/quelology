use warnings;
use 5.012;
use lib 'lib';
use Quelology::Config qw(schema amazon);

binmode STDOUT, ':encoding(UTF-8)';

my $schema = schema;
my @asins = (
            # lord of the rings (0, 1, 2)
            qw(0007269706 0618129081 0007269722),
            # demons by Peter V. Brett (3, 4)
            qw(0345518705 0345503813),
            # black magician (5, 6, 7)
            qw(006057528X 0060575298 0060575301),
            # traitor spy trilogy (8, 9)
            qw(0316037834 0316037869),
            # the Hobbit, Silmarillion, unfinished tales (10, ...)
            qw(0345296044 B0017PICLQ 0618154043),
            # Kushiel's Dart, Chosen, Avatar (13, ...)
            qw(0765342987 0765345048 0765347539),
            # Kushiel's Scion, Justice, Mercy (16, ...)
            qw(044661002X 0446610143 044661016X),
            # Naamah's Kiss, Curse, Blessing (19, ...)
            qw(0446198048 0446198056 0446198072),
            # Bartimaeus (just imported so there are a few 
            # related but not yet linked books in the DB (22 ... 26)
            qw(0786852550 1423123727 078683868X 142310420X 038560615X),
            # Kushiel (German) (27 .. 29)
            qw(3802581202 3802581210 3802581229),
            # Knuth TAoCP (boxed set 1..4a, 1, 2, 3, 4a)
            # index 30 to 34
            qw(0321751043 0201896834 0201896842 0201896850 0201038048),
    );

my @objs = map $schema->resultset('Title')->from_asin($_), @asins;
#for (@objs) {
#    say $_->title;
#}
my %rels = (
#    'The Lord of the Rings' => [0, 1, 2],
    'Demon Series' => [3, 4],
    'The Black Magician Trilogy' => [5, 6, 7],
    'The Traitor Spy Trilogy' => [8, 9],
    "Kushiel's Dart (Phedre)" => [13, 14, 15],
    "Kushiel's Scion (Imriel)" => [16, 17, 18],
    "Naamah's Gift (Moirin)" => [19, 20, 21],
    "Kushiels Auserwählte" => [27, 28, 29],
);

my %roots;

my $lotr = $schema->m->from_asin('0618260587');
$lotr->attach_rightmost_child(@objs[0, 1, 2]);
$roots{'The Lord of the Rings'} = $lotr;

while (my ($l, $r) = each %rels) {
    say "$l -> $r";

    my $root = $schema->m->create_root_with_children(
        { title => $l },
        @objs[@$r],
    );
    $roots{$l} = $root;
}

my $middleearth = $schema->m
        ->create_root_with_children({ title => 'Middle Earth' },
            @objs[11, 10], $roots{'The Lord of the Rings'}, $objs[12]);

# TODO: Add "Magician's Apprentice"
#my $trudi = $schema->resultset('Title')
#        ->create({ title => '' });
#$trudi->


my $terre_dange = $schema->m
    ->create_root_with_children({title => "Terre d'Ange"}, @roots{ "Kushiel's Dart (Phedre)", "Kushiel's Scion (Imriel)", "Naamah's Gift (Moirin)"});

$schema->m->by_id(31)->attach_rightmost_child(@objs[31..34]);

# an alias for testing
$schema->m->by_id(30)->update({same_as => 16});

# say '';
# my $rs = $schema->m->root_nodes;
# $rs->reset;
# 
# while (my $node = $rs->next) {
#     say $node->title;
#     for my $n ($node->descendants) {
#         say '   ' x $n->level, $n->title;
#     }
# }

say 'User setup';
# avoid ever-changing salts between different runs of this script:
srand 0;

for (qw/test admin root moritz/) {
    my $u = $schema->resultset('UserLogin')->create({
        name     =>  $_,
        password => $_ . '123',
    })
->create_related(info => {
        email       => "$_\@example.com",
        real_name   => ucfirst($_),
    });
}

say 'late imports';

# IDs    46         47         48
for ( qw(0756405890 360893815X 8499082475) ) {
    $schema->resultset('Title')->from_asin($_);
}
