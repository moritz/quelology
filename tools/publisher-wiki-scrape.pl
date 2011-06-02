use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::Config qw/schema/;
use WWW::Wikipedia::Links qw/wiki_links/;

binmode STDOUT, ':encoding(UTF-8)';

my $schema = schema;

my $publishers = $schema->resultset('Publisher');

my ($wp, $hp);
while (my $p = $publishers->next) {

    my $wiki = $p->search_related('links', {type => 'wikipedia'})->first;
    next unless $wiki;
    next if $p->search_related('links', {type => 'homepage'})->first;
    $wp++;

    my $res = wiki_links $wiki->url;

    my $homepage;
    if ($res->{homepage}) {
        $p->create_related('links', { type => 'homepage', url => $res->{homepage} });
        $hp++;
        say $wiki->url, '    ', $homepage;
    }
}
say $hp, ' / ', $wp;
