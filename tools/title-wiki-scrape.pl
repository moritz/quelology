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

    my $res = wiki_links $wikis->first->url;

    if ($res->{homepage} && $t->links->search({ type => 'homepage' })->count == 0) {
        $t->create_related('links', { type => 'homepage', url => $res->{homepage} });
        $hp++;
        say $t, '    ', $res->{homepage};
    }
    for (@{ $res->{translations} }) {
        if (length($_->{lang}) == 2) {
            $t->create_related('links',
                {
                    type    => 'wikipedia',
                    url     => $_->{url},
                    lang    => $_->{lang},
                },
            );
        }
    }
}
say $hp, ' / ', $translations;
