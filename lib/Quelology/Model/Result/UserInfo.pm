package Quelology::Model::Result::UserInfo;
use parent qw/DBIx::Class::Core/;
use utf8;
use mro 'c3';

__PACKAGE__->table('user_info');
__PACKAGE__->add_columns(
    id  => {
        data_type           => 'integer',
        is_nullable         => 0,
        is_auto_increment   => 1,
        is_numeric          => 1,
    },
    login_id    => {
        data_type           => 'integer',
        is_nullable         => 0,
        is_foreign_key      => 1,
        is_numeric          => 1,
    },
    qw/
        real_name
        email
    /
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('login', 'Quelology::Model::Result::UserLogin', 'login_id');

1;
