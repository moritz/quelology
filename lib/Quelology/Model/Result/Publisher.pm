package Quelology::Model::Result::Publisher;
use parent qw/DBIx::Class::Core/;

use utf8;
use strict;
use warnings;

__PACKAGE__->table('publisher');
__PACKAGE__->add_columns(qw/
    id
    isfdb_id
    name
    /);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many('publications', 'Quelology::Model::Result::Publication', 'publisher_id');
__PACKAGE__->has_many('publications_by_date', 'Quelology::Model::Result::Publication', 'publisher_id', 
    {
        group_by => \'EXTRACT(YEAR FROM publication_date)',
        order_by => \'publication_date',
    },
);
__PACKAGE__->has_many('links', 'Quelology::Model::Result::PublisherLink', 'publisher_id');

1;
