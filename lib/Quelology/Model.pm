package Quelology::Model;
use Carp qw(confess);

use parent qw/DBIx::Class::Schema/;

sub t {
    shift->resultset('Title');
}

sub p {
    shift->resultset('Publication');
}

sub login {
    my ($self, $username, $password) = @_;
    my $user = $self->resultset('UserLogin')->find({name => $username});
    unless ($user) {
        return;
    }
    $user->authenticate($password);
}

__PACKAGE__->load_namespaces();

1;
