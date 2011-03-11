package Quelology::Model::ResultSet::UserLogin;
use strict;
use utf8;
use 5.012;
use Carp qw(confess);
use parent 'DBIx::Class::ResultSet';
use mro 'c3';
use Crypt::Eksblowfish::Bcrypt qw(bcrypt_hash);
use constant COST => 9;

sub create {
    my ($self, $data) = @_;
    die "Need both name and password" unless exists($data->{name})
                                          && exists($data->{password});
    my $salt = join '', map { chr rand 255 } 1..16;
    my $hash = bcrypt_hash({
            key_null => 1,
            cost     => COST,
            salt     => $salt
    }, $data->{password});
    $self->next::method({
            name    => $data->{name},
            cost    => COST,
            salt    => $salt,
            pw_hash => $hash,
    });
}

sub authenticate {
    my ($self, $name, $password) = @_;
    my ($user) = $self->search({ name => $name });
    return unless $user;
    $user->authenticate($password);
}


1;
