package Quelology::Model::Result::TitleLink;
use parent qw/DBIx::Class::Core/;
use utf8;

__PACKAGE__->table('title_link');
__PACKAGE__->add_columns(
    'id',
    title_id   => {
        data_type       => 'integer',
        is_nullable     => 0,
        is_foreign_key  => 1,
        is_numeric      => 1,
    },
    qw/
    type
    url
    lang
    /,
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('title', 'Quelology::Model::Result::Title', 'title_id');

1;
