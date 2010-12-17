package XFacts::Model::Result::Medium;
use parent qw/DBIx::Class::Core/;
use aliased XFacts::Model::DropPoint => 'DropPoint';
use utf8;

__PACKAGE__->load_components(qw( Tree::NestedSet ));
__PACKAGE__->table('medium');
__PACKAGE__->add_columns(qw/
    id
    asin
    ISBN
    title
    made_by
    publisher
    amazon_url
    small_image
    medium_image
    large_image
    publish_year
    same_as
    root_id
    l
    r
    level
    /);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['asin']);
__PACKAGE__->belongs_to('root', 'XFacts::Model::Result::Medium', 'root_id');
__PACKAGE__->belongs_to('alias_for', 'XFacts::Model::Result::Medium', 'same_as');

__PACKAGE__->tree_columns({
        root_column     => 'root_id',
        left_column     => 'l',
        right_column    => 'r',
        level_column    => 'level',
});

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

    # we can't add before or after root node yet.
#    shift @things;
    pop @things;

    return @things;
}

sub is_root {
    my $self = shift;
    return $self->root_id == $self->id;
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

1;
