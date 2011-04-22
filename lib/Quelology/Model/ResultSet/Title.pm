package Quelology::Model::ResultSet::Title;
use strict;
use 5.012;
use Carp qw(confess);
use parent 'DBIx::Class::ResultSet';

sub by_id {
    my ($self, $id) = @_;
    my $obj = $self->find($id);
    die "No title with id '$id' found" unless $obj;
    return $obj;
}

sub from_asin {
    my ($self, $asin) = @_;
    my $pub = $self->result_source->schema
              ->resultset('Publication')->from_asin($asin);
    if (my $t = $pub->title_obj) {
        return $t;
    } else {
        return $self->new_from_publication($pub);
    }
}

sub new_from_publication {
    my ($self, $pub) = @_;
    my $new;
    $self->result_source->schema->txn_do(sub {
        $new = $self->create({
                title       => $pub->title,
                author      => $pub->author,
                publisher   => $pub->publisher,
                lang        => $pub->lang,
        });
        $pub->update({title_id => $new->id});
    });
    return $new;
}


# TODO: test if ->all() interferes with the current position in a resultset
#
# called as $rs->calc_property('title'), it will compute a comma-separated
# string of all the titles in $rs, sorted by frequency
sub calc_property {
    my ($self, $what) = @_;
    my %freq;
    for my $c ($self->all) {
        for (split /\s*,\s+/, $c->$what) {
            $freq{$_}++ if $_;
        }
    }
    my @things = reverse sort { $freq{$a} <=> $freq{$b} }
                              keys %freq;
    my $s = join ', ', @things;
    $s = substr($s, 0, 255) if length($s) > 255;
    return $s;
}


sub _join_sorted {
    my ($self, $values, $what, $children) = @_;
    return $values->{$what} if exists $values->{$what};
    my %freq;
    for my $c (@$children) {
        for (split /,\s+/, $c->$what) {
            $freq{$_}++ if $_;
        }
    }
    my @things = reverse sort { $freq{$a} <=> $freq{$b} }
                              keys %freq;
    return join ', ', @things;
}


sub create_root_with_children {
    my ($self, $values, @children) = @_;
    my %v = %$values;
    for (qw(lang)) {
        $v{$_} = $self->_join_sorted($values, $_, \@children);
    }
    delete $v{lang} if length($v{lang}) != 2;
    my $new = $self->create(\%v);
    $new->attach_rightmost_child(@children);
    return $new;
}

sub langs {
    my $self = shift;
    $self->search({
        lang => { '<>' =>  undef }
    },
    {
        select => [
            { count    => 'lang' },
            'lang'
        ],
        group_by    => 'lang',
        as          => [ qw/ count lang / ],
        order_by    => \'count DESC',
    });
}

=head3 with_different_languages
    
    returns a resultset of titles that have publications in different
    languages (which is a bad sign, because translations are supposed
    to be handled on the titles layer, not on the publications layer).

=cut

sub with_different_languages {
    shift->search_rs({
        'publications.lang' => { '<>' => undef },
    }, {
        join        => 'publications',
        distinct    => 1,
        having      => \'count(distinct(publications.lang)) > 1',
    });
}

sub root_nodes {
    my $self = shift;
    my $csa = $self->current_source_alias;
    $self->search({
        "$csa.id" => { '=' => \"$csa.root_id" },
    });
}

sub threads {
    my $self = shift;
    $self->root_nodes->search({ r => { '<>' => 2 }});
}

sub singles {
    my $self = shift;
    $self->root_nodes->search({ r => { '=' => 2 }});
}


1;
