package XFacts::Model::ResultSet::Medium;
use strict;
use 5.012;
use Carp qw(confess);

use parent 'DBIx::Class::ResultSet';

sub scalarify {
    @_ == 1 ? $_[0] : join ', ', @_;
}

sub unparen {
    my $t = shift;
    $t =~ s/\s*\([^()]+\)$//;
    $t;
}

sub from_asin {
    my ($self, $asin) = @_;
    my $row = $self->find({ asin => $asin });
    unless ($row) {
        my $a = XFacts::Config::amazon();
        my $m = $a->asin($asin);
        if ($m) {
            my $h = {
                asin            => $asin,
                title           => unparen($m->title),
                made_by         => scalarify($m->made_by),
                publisher       => scalarify($m->publisher),
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
