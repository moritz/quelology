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
like $m->author, qr/Tolkien/, 'author';
ok length($m->isbn) == 10 || length($m->isbn) == 13, 'isbn is 10 or 13 chars long';
is $m->lang, 'en', 'isbn-based language detection (en)';
is $m->language, 'English', 'human readable language';
is $schema->m->by_id(30)->lang, 'de', 'language detection (de)';
is $schema->m->by_id(30)->language, 'German', 'human redable language';
ok my $root = $m->root, 'can get thread root';
like $root->title, qr/middle earth/i, '...and it is the rigth one';
is $root->lang, 'en', 'language is propagated up to the root';

{
    my $tr = $schema->m->by_id(30)->translations;
    is $tr->count, 1, 'we know one translation of a Kushiel book';
    is $tr->first->lang, 'en', '... and it is English';

    $tr = $schema->m->by_id(16)->translations;
    is $tr->count, 1, 'translations symmetry (1)';
    is $tr->first->lang, 'de', 'symmetry (2)';

    my $en = $schema->m->by_id(14);
    my $de = $schema->m->by_id(28);
    $en->add_alias($de);
    is $en->translations->first->lang, 'de', 'can install translation with add_alias';
    is $de->translations->first->lang, 'en', '... and its symmetry prevails';
}

{
    # three languages
    my $en = $schema->m->by_id(46);
    my $de = $schema->m->by_id(47);
    my $es = $schema->m->by_id(48);
    $en->add_alias($de);
    $de->add_alias($es);
    is $en->translations->count, 2, 'Name of the Wind has two translations';
    is $de->translations->count, 2, 'symmetry (1)';
    is $es->translations->count, 2, 'symmetry (2)';
    for ($en, $de, $es) {
        $_->update({same_as => undef });
    }
    $en->add_alias($de);
    $es->add_alias($en);
    is $en->translations->count, 2, 'Name of the Wind has two translations';
    is $de->translations->count, 2, 'symmetry (1)';
    is $es->translations->count, 2, 'symmetry (2)';
}

# TODO: check the whole tree structure

ok !$schema->resultset('UserLogin')->authenticate('test', 'wrong'),
    'can NOT authenticate with wrong password';
ok !$schema->resultset('UserLogin')->authenticate('notthere', 'wrong'),
    'can NOT with non-existent user';

ok my $t = $schema->resultset('UserLogin')->authenticate('test', 'test123'),
    'CAN authenticate with correct credentials';
is $t->info->first->real_name, 'Test',             'real name';
is $t->info->first->email,     'test@example.com', 'email';



lives_ok {$t->update({password => 'newpw'}) } 'can update password';

ok !$schema->resultset('UserLogin')->authenticate('test', 'test123'),
    'can NOT authenticate with old credentials';
ok  $schema->resultset('UserLogin')->authenticate('test', 'newpw'),
    'CAN authenticate with new credentials';

$m = $schema->m->by_id(44);
my $computed_authors = $m->children->calc_property('author');
like $computed_authors, qr/J\.R\.R\. Tolkien/, 'calc_property returned Tolkien Senior';
like $computed_authors, qr/Christopher Tolkien/, 'calc_property returned Tolkien Junior';
like $computed_authors, qr/Alan Lee/, 'calc_property returned Alan Lee, whoever that might be';

# test some accessors
my @c = $m->children();
# @c = (silmarilion, hobbit, LOTR, Unifinished tales from Numenor)
ok $m->is_root, 'is_root on a root node';
for (@c) {
    ok !$_->is_root, "is_root on a non-root node (". $_->title . ")";
}
for ($m, $c[2]) {
    ok $_->has_leaves, "has_leaves (" . $_->title . ")";
}
for (@c[0, 1, 3]) {
    ok !$_->has_leaves, "has_leaves (" . $_->title . ")";
}
for ($m, @c) {
    ok !$_->is_single, "is_single (" . $_->title . ")";
}
ok $schema->m->by_id(23)->is_single, 'is single (+)';

is join(' ', map $_->tree_position, $m, @c),
    'root leaf leaf branch leaf', 'tree_position';

like $c[0]->attributions->first->name, qr/amazon/i, 'attribution name';
like $c[0]->attributions->first->url,  qr{^https?://.*?amazon\.}i,
    'attribution url';

done_testing;
