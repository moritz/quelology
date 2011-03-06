package Quelology::Model::Result::UserLogin;
use parent qw/DBIx::Class::Core/;
use utf8;
use Crypt::Eksblowfish::Bcrypt qw(bcrypt_hash);

__PACKAGE__->table('user_login');
__PACKAGE__->add_columns(qw/
    id
    name
    /,
    salt => {
        data_type => "bytea",
        is_nullable => 0,
    },
    'cost',
    pw_hash => {
        data_type => "bytea",
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['name']);

sub authenticate {
    my ($self, $password) = @_;
    my $hash = bcrypt_hash({
            name    => $self->name,
            cost    => $self->cost,
            salt    => $self->salt,
        }, $password);
    if ($hash eq $self->pw_hash) {
        return $self;
    } else {
        warn "password mismatch for user " . $self->name;
        return;
    }
}

1;
