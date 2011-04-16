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
    for (qw(author publisher lang)) {
        $v{$_} = $self->_join_sorted($values, $_, \@children);
    }
    delete $v{lang} if length($v{lang}) != 2;
    my $new = $self->create(\%v);
    $new->attach_rightmost_child(@children);
    return $new;
}

sub root_nodes {
    my $self = shift;
    $self->search({
        id => { '=' => \'root_id' },
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
