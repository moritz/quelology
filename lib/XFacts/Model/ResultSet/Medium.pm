package XFacts::Model::ResultSet::Medium;
use strict;
use 5.012;
use Carp qw(confess);

use parent 'DBIx::Class::ResultSet';

sub by_id {
    my $obj = shift->find(shift);
    return $obj->alias_for // $obj;
}

sub scalarify {
    @_ == 1 ? $_[0] : join ', ', @_;
}

sub unparen {
    my $t = shift;
    $t =~ s/\s*\([^()]+\)$//;
    $t;
}

sub _hash_from_xml_amazon {
    my $m = shift;
    my $h = {
        asin            => $m->asin,
        title           => unparen($m->title),
        made_by         => scalarify($m->made_by),
        publisher       => scalarify($m->publisher),
        amazon_url      => $m->url,
        small_image     => $m->image('s'),
        medium_image    => $m->image('m'),
        large_image     => $m->image('l'),
    };

    # get more information through a different module
    my $a = XFacts::Config::amazon_net();
    my $res = $a->search(asin => $h->{asin});
    if ($res->is_success) {
        # TODO: be more robust
        my ($book) = $res->properties;
        $h->{ISBN} = $book->isbn if $book->isbn;
        my $date = $book->publication_date // $book->ReleaseDate;
        my $year = (split /-/, $date)[0];
        $h->{publish_year} = $year if $year;
    }

    return $h;
}

sub websearch {
    my ($self, $keywords) = @_;
    my $amazon = XFacts::Config::amazon();
    my $a_res  = $amazon->search(
        keywords    => $keywords,
        type        => 'Books',
    );
#    die $a_res->message unless $a_res->is_success;
    my @r;
    for ($a_res->collection) {
        if (my ($r) = $self->search({asin => $_->asin})) {
            push @r, $r;
        } else {
            my $r = $self->create(_hash_from_xml_amazon($_));
            push @r, $r;
        }
    }
    return @r;
}

sub from_asin {
    my ($self, $asin) = @_;
    confess("No ASIN provided") unless defined($asin) && length $asin;
    my ($row) = $self->search({ asin => $asin });
    unless ($row) {
        my $a = XFacts::Config::amazon();
        my $m = $a->asin($asin);
        if ($m) {
            my $h = _hash_from_xml_amazon($m);
            $row = $self->create($h);
        } else {
            confess "Failed to retrieve medium with asin '$asin': neither in DB nor in amazon";
        }
    }
    return $row;
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
    for (qw(made_by publisher)) {
        $v{$_} = $self->_join_sorted($values, $_, \@children);
    }
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
