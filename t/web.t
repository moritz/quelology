use strict;
use warnings;
use 5.010;
use strict;
use utf8;
use Test::More;
use Test::Mojo;

use lib 't/lib';
use lib 'lib';
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

like $r->tx->res->dom->at('.series')->all_text,
     qr/James Cameron's Avatar/, 'series title';

$r->get_ok('/t/35263')
  ->status_is(200)
  ->text_like(title => qr/Kushiel's Legacy/)
  ->text_like('#content h1' => qr/Kushiel/)
  ;

$r->get_ok('/t/35256')
    ->status_is(200);


my $table = $r->tx->res->dom->at('#pub_50367');
my %h = map trim($_->all_text), $table->find('td')->each;

is $h{Language}, 'English',         'title data language';
is $h{ISBN},     '0312872402',      'title data ISBN';
is $h{Date},     '2003-04-01',      'title data pub year';
is $h{Publisher},'Tor',             'title data pub publisher';


$r->get_ok('/publication/50367')
    ->status_is(200)
    ->text_like(title => qr/Kushiel's Avatar/)
    ;
my $contents = $r->tx->res->dom->at('#pub_50367')->all_text;
like $contents, qr/Kushiel's Avatar/, 'book title appears in output';
like $contents, qr/view on amazon/i, 'Amazon link';

for my $page (qw/about login imprint/) {
    $r->get_ok("/$page")
        ->status_is(200)
    ;
}

for (qw(/edit/44 /shelf/connect)) {
    $r->get_ok($_)
        ->status_is(403, "GET $_ is auth protected");
}

for (qw(/lump/ /update/title /update/author /delete /dissolve /edit)) {
    $r->post_ok($_)
        ->status_is(403, "POST $_ is auth protected");
}
$r->post_form_ok('/login/', { username => 'test', password => 'test123' })
    ->status_is(302);
$r->header_like(Location => qr{/edit/44$}, 'redirect to the first forbidden location');

$r->get_ok('/edit/44')
    ->status_is(200, '/edit/$id is open after authentication');

$r->text_like('.flash'  => qr{log ?in}i, 'log in notification');

$r->get_ok('/nonexist/')
    ->status_is(404, 'non-existing URL returns 404');

done_testing;
