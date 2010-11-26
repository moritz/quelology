package XFacts::Model::ResultSet::Medium;
use strict;
use 5.012;
use Carp qw(confess);

use parent 'DBIx::Class::ResultSet';

sub from_asin {
    my ($self, $asin) = @_;
    my $row = $self->find({ asin => $asin });
    unless ($row) {
        my $a = XFacts::Config::amazon();
        my $m = $a->asin($asin);
        if ($m) {
            my $h = {
                asin            => $asin,
                title           => $m->title,
                made_by         => scalar($m->made_by),
                publisher       => scalar($m->publisher),
                amazon_url      => $m->url,
                small_image     => $m->image('s'),
                medium_image    => $m->image('m'),
                large_image     => $m->image('l'),
            };
            $row = $self->create($h);
        } else {
            confess "Failed to retrieve medium with asin '$asin': neither in DB nor in amazon";
        }
    }
    return $row;
}

sub root_nodes {
    my $self = shift;
    $self->search({
        id => { '=' => \'root_id' },
    });
}

1;
