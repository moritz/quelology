package Quelology::Model::Result::UserLogin;
use parent qw/DBIx::Class::Core/;
use utf8;
use mro 'c3';
use Crypt::Eksblowfish::Bcrypt qw(bcrypt_hash);

__PACKAGE__->table('user_login');
__PACKAGE__->add_columns(qw/
    id
    name
    created
    modified
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
__PACKAGE__->has_many('info', 'Quelology::Model::Result::UserInfo', 'login_id');

sub authenticate {
    my ($self, $password) = @_;
    my $hash = bcrypt_hash({
            cost    => $self->cost,
            salt    => $self->salt,
        }, $password);
    if ($hash eq $self->pw_hash) {
        return $self;
    } else {
        return;
    }
}

sub update {
    my ($self, $data) = @_;

    if (exists $data->{password}) {
        my %data_copy = %$data;
        my $new_pw = delete $data_copy{password};
        # TODO: check password strength (SEC)

        # TODO: make hack less ugly
        $data_copy{cost} =  Quelology::Model::ResultSet::UserLogin::COST();

        $data_copy{salt} = join '', map { chr rand 255 } 1..16;
        $data_copy{pw_hash} = bcrypt_hash(\%data_copy, $new_pw);
        $self->next::method(\%data_copy);
    } else {
        $self->next::method($data);
    }
}

1;
