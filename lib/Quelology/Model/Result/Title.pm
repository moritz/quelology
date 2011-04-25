package Quelology::Model::Result::Title;
use parent qw/DBIx::Class::Core/;
use aliased Quelology::Model::DropPoint => 'DropPoint';
use Locales;

use utf8;
use strict;
use warnings;

__PACKAGE__->load_components(qw( Tree::NestedSet ));
__PACKAGE__->table('title');
__PACKAGE__->add_columns(qw/
    id
    title
    same_as
    isfdb_id
    lang
    root_id
    l
    r
    level
    /);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('root',         'Quelology::Model::Result::Title', 'root_id');
__PACKAGE__->belongs_to('alias_for',    'Quelology::Model::Result::Title', 'same_as');
__PACKAGE__->has_many('aliases',        'Quelology::Model::Result::Title', 'same_as');
__PACKAGE__->has_many('attributions',   'Quelology::Model::Result::TitleAttribution', 'title_id');

__PACKAGE__->has_many('publications',   'Quelology::Model::Result::Publication',
                      'title_id', { order_by => \'publication_date'});

# need an unordered version to call ->min on it
__PACKAGE__->has_many('publications_unordered',
                      'Quelology::Model::Result::Publication',
                      'title_id');
__PACKAGE__->has_many('author_titles',
                      'Quelology::Model::Result::AuthorTitle',
                      'title_id');
__PACKAGE__->many_to_many(authors => author_titles => 'author');

__PACKAGE__->tree_columns({
        root_column     => 'root_id',
        left_column     => 'l',
        right_column    => 'r',
        level_column    => 'level',
});


sub date {
    my $self = shift;
    $self->publications_unordered->get_column('publication_date')->min;
}

sub thread_with_drop_points {
    my $self = shift;
    my @nodes = $self->nodes;
    my @things;

    my @todo;
    my $previous_level = 1;
    for my $i (0..$#nodes) {
        my $_ = $nodes[$i];
        my $level = $_->level;

        for (my $l = $previous_level; $l >= $level; $l--) {
            if (defined $todo[$l]) {
                push @things, $todo[$l];
                $todo[$l] = undef;
            }
        }

        $previous_level = $level;

        push @things, DropPoint->new(level => $level, where => 'before', id => $_->id );
        push @things, [$_];
        if ($nodes[$i+1] && $nodes[$i+1]->level > $level) {
            # we have descendants
            # so don't add a 'append stuff below' here
        } else {
        # no descendants
            push @{$things[-1]}, DropPoint->new(level => $level, where => 'below', id => $_->id );
        }

        my $has_later_sibling = 0;
        {
            for my $j ($i+1 .. $#nodes) {
                $has_later_sibling = 1 if $level == $nodes[$j]->level;
                last if $level >= $nodes[$j]->level;
            }
        }
        unless ($has_later_sibling) {
            $todo[$level] = DropPoint->new(level => $level, 'where' => 'after', id => $_->id );
        }
    }
    push @things, grep defined, reverse @todo;

    return @things;
}

sub is_root {
    my $self = shift;
    return $self->root_id == $self->id;
}

sub is_single {
    $_[0]->r == 2;
}

sub short_title {
    my $self = shift;
    my $t = $self->title;
    my $max_length = 20;
    if (length $t > $max_length) {
        return substr($t, 0, $max_length) . '…';
    } else {
        return $t;
    }
}

sub has_leaves {
    my $self = shift;
    $self->l + 1 != $self->r;
}

sub tree_position {
    my $self = shift;
    $self->is_root           ? 'root'
        : $self->has_leaves  ? 'branch'
        :                      'leaf';
}

# TODO: initialize with configurable locale
my $locales = Locales->new('en');

sub language {
    my $lang = shift->lang;
    return $locales->code2language($lang) if defined $lang;
    return;
}

sub translations {
    my $self        = shift;
    my $own_lang    = $self->lang;
    my $alias       = $self->alias_for;
    my $target_id   = ($alias // $self)->id;
    $self->result_source->resultset->search({
        lang    => { '<>', $own_lang },
        -or => [
            same_as     => $target_id,
            id          => $target_id,
        ],
    });
}

sub add_alias {
    my ($self, $other) = @_;
    my $own_alias   = $self->same_as;
    my $other_alias = $other->same_as;
    return if $self->id == $other->id;
    return if defined($other_alias) && $other_alias == $self->id;
    return if defined($own_alias)   && $own_alias   == $other->id;
    if (defined($other_alias) || $other->aliases->count) {
        if (defined($own_alias) || $self->aliases->count ) {
            die "Don't know how to join two aliased groups yet";
        } else {
            $self->update({same_as => $other_alias // $other->id});
        }
    } else {
        $other->update({same_as => $own_alias // $self->id});
    }
}

sub attribute {
    my ($self, $url) = @_;
    if ($url =~ /\b(amazon|isfdb)\./) {
        $self->create_related('attributions',
            {
                name    => $1,
                url     => $url,
            },
        );
    } else {
        die "Don't know how to extract attribution name from '$url'."
            . " Please call ->create_related(attributions => { ... }) directly yourself.";
    }
}

=head3 single_author

If the invocant and all of its descendents all have the same one author, that
author is returned, and C<undef> otherwise.

=cut

sub single_author {
    my $self = shift;
    my $all = $self->result_source->resultset->search({root_id => $self->id});
    my @author_ids = $all->search_related('author_titles', undef, {
            select => [
                { distinct => 'author_id' }
            ],
            as => [ 'author_id' ],
            rows    => 2,
    });
    if (@author_ids == 1) {
        return $self->result_source->schema->a->by_id($author_ids[0]->get_column('author_id'));
    }
    return undef;
}

sub split_by_language {
    my $self = shift;

    # TODO: wrap in transaction
    my @pubs = $self->publications(
        {
            lang => { '<>' => $self->lang }
        },
    );

    return $self unless @pubs;

    my @new_titles = $self;
    my %lang;
    push @{$lang{$_->lang}}, $_ for @pubs;

    LANGS:
    for my $l (keys %lang) {
        my @p = @{$lang{$l}};
        my $first = shift @p;
        for (@p) {
            if ($first->title ne $_->title) {
                warn sprintf "Publications for %s in language $l differ in title (%s vs. %s), don't know how to split title off", $self->title, $first->title, $_->title;
                next LANGS;
            }
        }

        my $nt = $self->create_related('aliases', {
            title   => $first->title,
            lang    => $l,
        });
        for ($self->author_titles) {
            $nt->create_related('author_titles', {
                author_id   => $_->author_id,
            });
        }
        for ($first, @p) {
            $_->update({
                title_id => $nt->id,
            });
        }
        push @new_titles, $nt;
    }
    return @new_titles;
}

1;
