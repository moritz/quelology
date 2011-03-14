use strict;
use warnings;
use Test::More;
use lib 't/lib';
use Quelology::Test::Setup;
init_db();

ok 1, 'alive';
done_testing;
