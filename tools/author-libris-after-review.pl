use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::Config qw/schema/;
use WebService::Libris;
use Mojo::URL;
binmode STDOUT, ':encoding(UTF-8)';
binmode ARGS, ':encoding(UTF-8)';
$| = 1;

my $schema = schema;
while (<>) {
    chomp;
    next unless s/^REVIEW:\s*//;
    my ($id, $libris_id) = split;
    my $l = WebService::Libris->new(type => 'auth', id => $libris_id, cache_dir => 'data/libris/');
    my $a = $schema->a->by_id($id);
    eval {
        $schema->txn_do( sub {
            $a->update({ libris_id => $l->id });
            $a->create_related('links', {
                type    => 'libris',
                lang    => 'en',
                url     => "http://libris.kb.se/auth/" . $l->id,
            });
            my $same_as = $l->same_as;
            if ($same_as) {
                my $mu = Mojo::URL->new($same_as);
                my $type = (split /\./, $mu->host)[-2];
                say "    $type: $same_as";
                $a->create_related('links', {
                    type    => $type,
                    lang    => 'en',
                    url     => $same_as,
                });
            }
        });
    };
    warn $@ if $@;
}
