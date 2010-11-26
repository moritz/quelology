use warnings;
use 5.012;
use lib 'lib';
use XFacts::Config qw(schema amazon);

my $schema = schema;
my @asins = qw(0618574948 0618129081 0618574972 0345518705 0345503813
              006057528X 0060575298 0060575301);
my @objs = map $schema->resultset('Medium')->from_asin($_), @asins;
my %rels = (
    0   => 1,
    1   => 2,
    3   => 4,
    5   => 6,
    6   => 7,
);
while (my ($l, $r) = each %rels) {
    $objs[$l]->create_related('sequels', {
            second => $objs[$r]->id,
    });
}
