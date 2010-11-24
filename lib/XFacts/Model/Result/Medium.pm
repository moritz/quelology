package XFacts::Model::Result::Medium;
use parent qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw( Tree::NestedSet ));
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
    publish_year
    root_id
    l
    r
    level
    /);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['asin']);

__PACKAGE__->tree_columns({
        root_column     => 'root_id',
        left_column     => 'l',
        right_column    => 'r',
        level_column    => 'level',
});
1;
