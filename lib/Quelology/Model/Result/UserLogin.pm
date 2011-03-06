package Quelology::Model::Result::UserLogin;
use parent qw/DBIx::Class::Core/;
use utf8;

__PACKAGE__->table('user_login');
__PACKAGE__->add_columns(qw/
    id
    name
    salt
    cost
    pw_hash
/);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['name']);

1;
