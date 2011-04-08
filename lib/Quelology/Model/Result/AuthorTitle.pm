package Quelology::Model::Result::AuthorTitle;
use parent qw/DBIx::Class::Core/;
use utf8;

__PACKAGE__->table('author_title_map');
__PACKAGE__->add_columns(
    qw/
    id
    author_id
    title_id
    /
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('author', 'Quelology::Model::Result::Author', 'author_id');
__PACKAGE__->belongs_to('title', 'Quelology::Model::Result::Title', 'title_id');

1;
