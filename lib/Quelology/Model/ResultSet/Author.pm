package Quelology::Model::ResultSet::Author;
use 5.010;
use strict;
use Carp qw(confess);
use parent 'DBIx::Class::ResultSet';

sub by_id {
    my ($self, $id) = @_;
    my ($obj) = $self->find($id);
    confess "No author with id '$id' found" unless $obj;
    return $obj;
}

1;
