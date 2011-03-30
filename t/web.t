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

like $r->tx->res->dom->at('.series')->all_text,
     qr/Auserwählte/, 'ul content + utf-8';

$r->get_ok('/m/45')
  ->status_is(200)
  ->text_like(title => qr/Terre d'Ange/)
  ->text_like(title => qr/Jacqueline Carey/)
  ->text_like('#content h1' => qr/Terre d'Ange/)
  ;

$r->get_ok('/m/10')
    ->status_is(200);


my $table = $r->tx->res->dom->at('#content table');
my %h = map trim($_->all_text), $table->find('td')->each;

is $h{Language}, 'English',         'medium data language';
is $h{ISBN},     '0316037869',      'medium data ISBN';
is $h{Author},   'Trudi Canavan',   'medium data author';
is $h{'Publication year'}, 2011,    'medium data pub year';
is $h{Publisher}, 'Orbit',          'medium data pub publisher';


$r->get_ok('/details/14')
    ->status_is(200)
    ->text_like(title => qr/Kushiel's Dart/)
    ->text_like(title => qr/Jacqueline Carey/)
    ;
my $contents = $r->tx->res->dom->at('#medium_14')->all_text;
like $contents, qr/Kushiel's Dart/, 'book title appears in output';
like $contents, qr/Jacqueline Carey/, 'book author appears in output';
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

for (qw(/lump/ /update/title /update/made_by /delete /dissolve /edit)) {
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
