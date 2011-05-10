package Quelology::Model::ResultSet::Publication;
use strict;
use 5.010;
use strict;
use Carp qw(confess);
use ISBN::Country qw/isbn_extract/;

use parent 'DBIx::Class::ResultSet';

sub by_id {
    my ($self, $id) = @_;
    my $obj = $self->find($id);
    die "No publication with id '$id' found" unless $obj;
    return $obj;
}

1;
