package Quelology::Model;
use Carp qw(confess);

use parent qw/DBIx::Class::Schema/;

sub m {
    shift->resultset('Medium');
}

sub login {
    shift->resultset('UserLogin');
}

__PACKAGE__->load_namespaces();

1;
