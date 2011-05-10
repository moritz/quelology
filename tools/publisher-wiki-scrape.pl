use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::Config qw/schema/;
use Mojo::UserAgent;

binmode STDOUT, ':encoding(UTF-8)';

my $schema = schema;

my $publishers = $schema->resultset('Publisher');

my ($wp, $hp);
while (my $p = $publishers->next) {

    my $wiki = $p->search_related('links', {type => 'wikipedia'})->first;
    next unless ($wiki);
    next if $p->search_related('links', {type => 'homepage'})->first;
    $wp++;

    my $res = Mojo::UserAgent->new->get($wiki->url)->res;

    my $homepage;
    my $vcard = $res->dom->at('table.vcard');
    next unless $vcard;
    for ($vcard->find('tr')->each) {
        if ($_->all_text =~ 'Official website') {
            $homepage = $_->at('a')->attrs->{href};
            last;
        }
    }
    if ($homepage) {
        $p->create_related('links', { type => 'homepage', url => $homepage });
        $hp++;
        say $wiki->url, '    ', $homepage;
    }
}
say $hp, ' / ', $wp;
