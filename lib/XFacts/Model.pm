package XFacts::Model;
use Carp qw(confess);

use parent qw/DBIx::Class::Schema/;

__PACKAGE__->load_namespaces();

1;
