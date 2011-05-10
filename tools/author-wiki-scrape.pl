use warnings;
use 5.010;
use strict;
use lib 'lib';
use Quelology::Config qw/schema/;
use Mojo::UserAgent;
binmode STDOUT, ':encoding(UTF-8)';

my $ua = Mojo::UserAgent->new;

my $authors = schema->a;
say $authors->count;
while (my $a = $authors->next) {
    if (my ($l) = $a->search_related('links', {type => 'wikipedia', lang => 'en'})) {
        if ($a->search_related('links', {type => 'wikipedia'})->count > 1) {
            say 'skipping ' , $a->name, ', it already has >= 2 wiki links';
            next;
        }
        say $a->name, ' ', $l->url;
        my $langs =  $ua->get($l->url)->res->dom->at('#p-lang');
        next unless $langs;
        print '    ';
        my $found;
        for ($langs->find('li')->each) {
            my $lang = (split '-', $_->attrs->{class})[1];
            if (length($lang) != 2) {
                warn "ignoring lang $lang\n";
                next;
            }
            next if $a->search_related('links', { type => 'wikipedia', lang => $lang})->count;
            my $url  =  $_->at('a')->attrs->{href};
            $a->create_related('links', { type => 'wikipedia', lang => $lang, url => $url });
            $found++;
            print $lang, ' ';
        }
        print "\n";
        if ($found) {
            $a->create_related('attributions', { name => 'wikipedia', url => $l->url });
        }
    }
}
