use warnings;
use 5.012;
use lib 'lib';
use Quelology::Config qw/schema amazon/;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

my $c = 0;
my $pubs = schema->t->search(undef, { rows => 500, order_by => \'RANDOM()' });
while (my $t = $pubs->next) {
    my $authors = join ' ', map $_->name, $t->authors;
    my $similar = amazon->search(keywords => '"' . $t->title . '" ' . $authors);
    say $t->title;
    for (@{ $similar->items }) {
        next if schema->p->find({ asin => $_->asin });
        next if schema->rp->find({ asin => $_->asin });
        next if length($_->title) > 255;
        next unless $_->medium_image;
        eval {
            my $rp = schema->rp->import_from_amazon_item($_);
            $rp->update({maybe_title_id => $t->id });
            say '    ', $rp->title, ' ', $rp->publication_date;
            $c++;
        };
        say $@ if $@;
    }
    sleep 1;
}

say "Imported $c raw publications";
