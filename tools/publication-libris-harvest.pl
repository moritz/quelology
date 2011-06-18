use 5.010;
use strict;
use warnings;
use lib 'lib';
use Quelology::Config qw/schema/;
use WebService::Libris;
use Time::HiRes qw/sleep/;
binmode STDOUT, ':encoding(UTF-8)';

my $s = schema;
my $rs = $s->p->search({ isbn => { '<>' => undef }, lang => ['sv', 'no', 'nn', 'nb', 'dk', undef]});

while (my $p = $rs->next) {
    say $p->title;
    my $l = WebService::Libris->search_for_isbn($p->isbn);
    if ($l) {
        say '   libris id: ', $l->id;
        eval {
            $p->update({ libris_id => $l->id });
        };
        warn $@ if $@;
        eval {
            if (!$p->lang && $l->language) {
                say '    updating language to ', $l->language;
                $p->update({ lang => $l->language });
            }
        };
        warn $@ if $@;
    }
    # Don't DOS the poor server
    sleep 0.2;
}
