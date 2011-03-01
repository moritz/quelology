package Quelology::Model;
use Carp qw(confess);

use parent qw/DBIx::Class::Schema/;

sub m {
    shift->resultset('Medium');
}

__PACKAGE__->load_namespaces();

1;
