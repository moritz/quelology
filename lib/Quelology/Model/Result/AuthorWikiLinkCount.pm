package Quelology::Model::Result::AuthorWikiLinkCount;
use parent qw/DBIx::Class::Core/;
use utf8;

# note that this wraps a view, so don't try to update any columns

__PACKAGE__->table('author_wiki_link_count');
__PACKAGE__->add_columns(
    author_id   => {
        data_type       => 'integer',
        is_nullable     => 0,
        is_foreign_key  => 1,
        is_numeric      => 1,
    },
    'link_count',
);

__PACKAGE__->set_primary_key('author_id');
__PACKAGE__->belongs_to('author', 'Quelology::Model::Result::Author', 'author_id');

1;
