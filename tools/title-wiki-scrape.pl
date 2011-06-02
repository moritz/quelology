use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::Config qw/schema/;
use WWW::Wikipedia::Links qw/wiki_links/;

binmode STDOUT, ':encoding(UTF-8)';

my $schema = schema;

my $titles = $schema->t->search(
    {
        'links.type'    => 'wikipedia',
    },
    {
        join        => 'links',
    },
);

my ($hp, $translations) = (0, 0);

while (my $t = $titles->next) {

    my $wikis = $t->links->search({ type => 'wikipedia' });
    next if $wikis->count != 1;

    my $wiki = $wikis->first;
    say "Querying ", $wiki->url;
    my $res = wiki_links $wiki->url;

    if ($res->{official_website} && $t->links->search({ type => 'homepage' })->count == 0) {
        $t->create_related('links', { type => 'homepage', url => $res->{official_website} });
        $hp++;
        say $t, '    ', $res->{official_website};
    }
    for (@{ $res->{translations} }) {
        if (length($_->{lang}) == 2) {
            my $add_to;
            if ($add_to = $t->translations->search({ lang => $_->{lang} })->first) {
            } else {
                $add_to = $t;
            }
            $add_to->create_related('links',
                {
                    type    => 'wikipedia',
                    url     => $_->{url},
                    lang    => $_->{lang},
                },
            );
        }
        $translations++;
    }
}
say $hp, ' / ', $translations;
