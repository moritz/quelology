use strict;
use warnings;
use 5.012;

use Test::More;
use lib 't/lib';
use lib 'lib';
use Quelology::Test::Setup;
init_db();

BEGIN { use_ok('Quelology::Config', 'schema') }

ok my $schema = schema(), 'can get a schema';
ok my $m = $schema->m->by_id(1), 'medium by id';
like $m->title, qr/Lord of the Rings/, 'can access title';
like $m->made_by, qr/Tolkien/, 'made_by';
is length($m->ISBN), 10, 'ISBN is 10 chars long';

done_testing;
