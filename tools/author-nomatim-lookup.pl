use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::Config qw/schema/;
use Mojo::UserAgent;
use Mojo::URL;

my $email = $ENV{EMAIL}
        or die "please specify your email address in the EMAIL env variable";
my $s = schema;
my %seen;
my $rs = $s->a->search(
    {
        birthplace => { '<>' => undef },
        birthplace_lat => undef,
    }
);

# see http://wiki.openstreetmap.org/wiki/Nominatim
my $base_url = Mojo::URL->new('http://nominatim.openstreetmap.org/search?');
my $ua = Mojo::UserAgent->new->name('Quelology + Mojolicious (Perl)');

while (my $author = $rs->next) {
    my $place = $author->birthplace;
    if ($seen{$place}) {
        $author->update({
                birthplace_lat  => $seen{$place}[0],
                birthplace_lon  => $seen{$place}[1],
        });
    } else {
        my $url = $base_url->clone;
        $url->query(
            format  => 'json',
            q       => $place,
            email   => $email,
            limit   => 1,
        );
        my $json = $ua->get($url)->res->json;
        my $lat = $json->[0]{lat};
        my $lon = $json->[0]{lon};
        unless ($lat && $lon) {
            say "No result for $place";
            next;
        }
        $author->update({
                birthplace_lat  => $lat,
                birthplace_lon  => $lon,
        });
        $seen{$place} = [$lat, $lon];
        say "$place -> ($lat, $lon)";
        sleep 10;
    }
}
