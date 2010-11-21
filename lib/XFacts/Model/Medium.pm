package XFacts::Model::Medium;
use parent qw/DBIx::Class::Core/;

__PACKAGE__->table('medium');
__PACKAGE__->add_columns(qw/
    id
    asin
    ISBN
    title
    made_by
    publisher
    amazon_url
    small_image
    medium_image
    large_image
    publish_date
    /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['asin']);


1;
