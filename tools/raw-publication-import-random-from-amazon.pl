use warnings;
use 5.012;
use lib 'lib';
use Quelology::Config qw/schema amazon/;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

my $c = 0;
my $pubs = schema->p->search(undef, { rows => 200, order_by => \'RANDOM()' });
while (my $p = $pubs->next) {
    my $similar = amazon->search(keywords => '"' . $p->title . '"');
    say $p->title;
    for (@{ $similar->items }) {
        next if $p->asin eq $_->asin;
        next if schema->p->find({ asin => $_->asin });
        next if schema->rp->find({ asin => $_->asin });
        next if length($_->title) > 255;
        eval {
            my $rp = schema->rp->import_from_amazon_item($_);
            say '    ', $rp->title, ' ', $rp->publication_date;
            $c++;
        };
        say $@ if $@;
    }
    sleep 1;
}

say "Imported $c raw publications";
