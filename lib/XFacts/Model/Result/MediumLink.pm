package XFacts::Model::Result::MediumLink;
use parent qw/DBIx::Class::Core/;

__PACKAGE__->table('medium_link');
__PACKAGE__->add_columns(qw/
    id
    first
    second
    /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['first', 'second']);
__PACKAGE__->belongs_to('left',  'XFacts::Model::Result::Medium', 'first');
__PACKAGE__->belongs_to('right', 'XFacts::Model::Result::Medium', 'second');

1;
