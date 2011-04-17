package Quelology::Model::ResultSet::Publisher;
use strict;
use 5.012;

use parent 'DBIx::Class::ResultSet';

sub by_id {
    my ($self, $id) = @_;
    my $obj = $self->find($id);
    die "No publsher with id '$id' found" unless $obj;
    return $obj;
}

1;
