use warnings;
use 5.010;
use strict;
use lib 'lib';
use Quelology::Config qw/schema amazon/;
use Quelology::XISBNImport qw/from_isbn/;
use List::MoreUtils qw/uniq/;
use Locales;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

my $locales = Locales->new();

my $schema = schema;
my $rs = $schema->t->search({r => { '>' => \'l + 1'}, lang => { '<>' => undef}});
while (my $root = $rs->next) {
    my %lang;
    my $total;
    for my $t ($root->children) {
        $total++;
        for ($t->translations) {
            next unless defined $_->lang;
            push @{$lang{$_->lang}}, $_;
        }
    }
    for (keys %lang) {
        if (@{$lang{$_}} == $total && $_ ne $root->lang) {
            printf "Title '%s' (id %d) has %d children that are all translated into %s\n", $root->title, $root->id, $total, $_;
            build_translation($root, $_, $lang{$_});
        }
    }
}

sub build_translation {
    my ($orig, $lang, $trans) = @_;
    for (@$trans) {
        if ($_->l != 1) {
            printf "    '%s' (%s) is already part of a tree, doing nothing\n",
                    $_->title, $_->lang;
            return;
        }
    }
    my $trans_title;
    if (@$trans == 1 && $orig->title eq $orig->children->first->title) {
        # doesn't make much sense, but we'll mirror the structure anyway
        $trans_title = $trans->[0]->title;
    } else {
        $trans_title = sprintf "[[%s translation of %s]]",
                              $locales->get_language_from_code($lang), $orig->title;
    }
    say "    $lang: '$trans_title'";
    $schema->txn_do(sub {
        my $new = $schema->t->create_root_with_children(
            {
                title => $trans_title,
            },
            @$trans,
        );
        $new->update({same_as => $orig->id});
        for ($orig->author_titles) {
            $new->create_related('author_titles', { author_id => $_->author_id });
        }
        say '    ', $new->id;
    });

}
