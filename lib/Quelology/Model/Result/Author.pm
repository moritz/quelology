package Quelology::Model::Result::Author;
use parent qw/DBIx::Class::Core/;

use utf8;
use strict;
use warnings;

__PACKAGE__->table('author');
__PACKAGE__->add_columns(qw/
    id
    name
    legal_name
    birthplace
    birthplace_lat
    birthplace_lon
    birthdate
    deathdate
    /);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many('author_titles', 'Quelology::Model::Result::AuthorTitle',
                      'author_id');
__PACKAGE__->has_many('attributions',
                'Quelology::Model::Result::AuthorAttribution', 'author_id');
__PACKAGE__->many_to_many('titles', 'author_titles', 'title');

1;
