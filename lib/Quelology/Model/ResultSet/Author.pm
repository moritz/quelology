package Quelology::Model::ResultSet::Author;
use 5.012;
use Carp qw(confess);
use ISBN::Country qw/isbn_extract/;

use parent 'DBIx::Class::ResultSet';

sub by_id {
    my ($self, $id) = @_;
    my ($obj) = $self->find($id);
    die "No author with id '$id' found" unless $obj;
    return $obj;
}

1;
