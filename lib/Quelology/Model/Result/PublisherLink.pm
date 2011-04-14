package Quelology::Model::Result::PublisherLink;
use parent qw/DBIx::Class::Core/;
use utf8;

__PACKAGE__->table('publisher_link');
__PACKAGE__->add_columns(
    'id',
    publisher_id   => {
        data_type       => 'integer',
        is_nullable     => 0,
        is_foreign_key  => 1,
        is_numeric      => 1,
    },
    qw/
    type
    url
    /,
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('publisher', 'Quelology::Model::Result::Publisher', 'publisher_id');

1;
