use strict;
use warnings;
use 5.012;
use utf8;
use Test::More;
use Test::Mojo;

use lib 't/lib';
use Quelology::Test::Setup;
init_db();

use FindBin;
$ENV{MOJO_HOME} = "$FindBin::Bin/../web/";
require "$ENV{MOJO_HOME}/quelology";

my $t = Test::Mojo->new;
my $r = $t->get_ok('/')
  ->status_is(200)
  ->text_like(title => qr/Quelology/)
  ;

like $r->tx->res->dom->at('ul')->all_text,
     qr/Auserwählte/, 'ul content + utf-8';


done_testing;
