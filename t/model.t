use strict;
use warnings;
use 5.010;
use strict;
use utf8;

use Test::More;
use Test::Exception;
use lib 't/lib';
use lib 'lib';
use Quelology::Test::Setup;
init_db();

BEGIN { use_ok('Quelology::Config', 'schema') }

ok my $schema = schema(), 'can get a schema';
ok my $m = $schema->t->by_id(35254), 'medium by id';
is $m->title, "Kushiel's Dart", 'can access title';
like $m->authors->first->name, qr/Carey/, 'author';
my $isbn = $m->publications->first->isbn;
ok length($isbn) == 10 || length($isbn) == 13, 'isbn is 10 or 13 chars long';
is $m->lang, 'en', 'lang';
is $m->language, 'English', 'human readable language';
ok my $root = $m->root, 'can get thread root';
is $root->title, "Kushiel's Legacy Universe", '...and it is the rigth one';
is $root->lang, 'en', 'language is propagated up to the root';

{
    my $tr = $schema->t->by_id(35254)->translations;
    is $tr->count, 1, 'we know one translation of a Kushiel book';
    is $tr->first->lang, 'fr', '... and it is French';
    is $tr->first->title, 'La marque', '... correct title';

    my $trans_id = $tr->first->id;

    $tr = $schema->t->by_id($trans_id)->translations;
    is $tr->count, 1, 'translations symmetry (1)';
    is $tr->first->lang, 'en', 'symmetry (2)';

#    my $en = $schema->t->by_id(14);
#    my $de = $schema->t->by_id(28);
#    $en->add_alias($de);
#    is $en->translations->first->lang, 'de', 'can install translation with add_alias';
#    is $de->translations->first->lang, 'en', '... and its symmetry prevails';
}

#{
#    # three languages
#    my $en = $schema->t->by_id(46);
#    my $de = $schema->t->by_id(47);
#    my $es = $schema->t->by_id(48);
#    $en->add_alias($de);
#    $de->add_alias($es);
#    is $en->translations->count, 2, 'Name of the Wind has two translations';
#    is $de->translations->count, 2, 'symmetry (1)';
#    is $es->translations->count, 2, 'symmetry (2)';
#    for ($en, $de, $es) {
#        $_->update({same_as => undef });
#    }
#    $en->add_alias($de);
#    $es->add_alias($en);
#    is $en->translations->count, 2, 'Name of the Wind has two translations';
#    is $de->translations->count, 2, 'symmetry (1)';
#    is $es->translations->count, 2, 'symmetry (2)';
#}

# TODO: check the whole tree structure

ok  $schema->resultset('UserLogin')->create({
        name     => 'test',
        password => 'test123',
}), 'Can create a new user';

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

#$m = $schema->t->by_id(44);
#my $computed_authors = $m->children->calc_property('author');
#like $computed_authors, qr/J\.R\.R\. Tolkien/, 'calc_property returned Tolkien Senior';
#like $computed_authors, qr/Christopher Tolkien/, 'calc_property returned Tolkien Junior';
#like $computed_authors, qr/Alan Lee/, 'calc_property returned Alan Lee, whoever that might be';
#
## test some accessors
#my @c = $m->children();
## @c = (silmarilion, hobbit, LOTR, Unifinished tales from Numenor)
#ok $m->is_root, 'is_root on a root node';
#for (@c) {
#    ok !$_->is_root, "is_root on a non-root node (". $_->title . ")";
#}
#for ($m, $c[2]) {
#    ok $_->has_leaves, "has_leaves (" . $_->title . ")";
#}
#for (@c[0, 1, 3]) {
#    ok !$_->has_leaves, "has_leaves (" . $_->title . ")";
#}
#for ($m, @c) {
#    ok !$_->is_single, "is_single (" . $_->title . ")";
#}
#ok $schema->t->by_id(23)->is_single, 'is single (+)';
#
#is join(' ', map $_->tree_position, $m, @c),
#    'root leaf leaf branch leaf', 'tree_position';
#
#my $attr =$c[0]->publications->first->attributions->first;
#like $attr->name, qr/amazon/i, 'attribution name';
#like $attr->url,  qr{^https?://.*?amazon\.}i,
#    'attribution url';
#
#{
#    is $schema->t->by_id(45)->single_author, 'Jacqueline Carey',
#        'single_author (+)';
#    ok !defined($schema->t->by_id(44)->single_author), 'single_author (-)';
#}
#
done_testing;
