use strict;
use warnings;
use 5.012;

use Test::More;
use Test::Exception;
use lib 't/lib';
use lib 'lib';
use Quelology::Test::Setup;
init_db();

BEGIN { use_ok('Quelology::Config', 'schema') }

ok my $schema = schema(), 'can get a schema';
ok my $m = $schema->m->by_id(1), 'medium by id';
like $m->title, qr/Lord of the Rings/, 'can access title';
like $m->made_by, qr/Tolkien/, 'made_by';
ok length($m->ISBN) == 10 || length($m->ISBN) == 13, 'ISBN is 10 or 13 chars long';
ok my $root = $m->root, 'can get thread root';
like $root->title, qr/middle earth/i, '...and it is the rigth one';

# TODO: check the whole tree structure

ok !$schema->resultset('UserLogin')->authenticate('test', 'wrong'),
    'can NOT authenticate with wrong password';
ok !$schema->resultset('UserLogin')->authenticate('notthere', 'wrong'),
    'can NOT with non-existent user';

ok my $t = $schema->resultset('UserLogin')->authenticate('test', 'test123'),
    'CAN authenticate with correct credentials';

lives_ok {$t->update({password => 'newpw'}) } 'can update password';

ok !$schema->resultset('UserLogin')->authenticate('test', 'test123'),
    'can NOT authenticate with old credentials';
ok  $schema->resultset('UserLogin')->authenticate('test', 'newpw'),
    'CAN authenticate with new credentials';

done_testing;
