package Quelology::Model::Result::AuthorLink;
use parent qw/DBIx::Class::Core/;
use utf8;

__PACKAGE__->table('author_link');
__PACKAGE__->add_columns(
    'id',
    author_id   => {
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
__PACKAGE__->belongs_to('author', 'Quelology::Model::Result::Author', 'author_id');

1;
