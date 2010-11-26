use warnings;
use 5.012;
use lib 'lib';
use XFacts::Config qw(schema amazon);

my $schema = schema;
my @asins = qw(0618574948 0618129081 0618574972 0345518705 0345503813
              006057528X 0060575298 0060575301);
my @objs = map $schema->resultset('Medium')->from_asin($_), @asins;
for (@objs) {
    say $_->title;
}
my %rels = (
    'The Lord of the Ring' => [0, 1, 2],
    'Demon Series' => [3, 4],
    'The Black Magician Trilogy' => [5, 6, 7],
);
while (my ($l, $r) = each %rels) {
    say "$l -> $r";
    my $root = $schema->resultset('Medium')->create({
            title => $l,
    });
    $root->attach_rightmost_child($objs[$_]) for @$r;
}
