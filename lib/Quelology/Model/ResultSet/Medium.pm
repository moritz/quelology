package Quelology::Model::ResultSet::Medium;
use strict;
use 5.012;
use Carp qw(confess);
use ISBN::Country qw/isbn_extract/;

use parent 'DBIx::Class::ResultSet';

sub by_id {
    my ($self, $id) = @_;
    my $obj = $self->find($id);
    die "No medium with id '$id' found" unless $obj;
    my $a = $obj->alias_for;
    return $obj unless $a;
    if (defined($a->lang) && defined($obj->lang) && $a->lang eq $obj->lang) {
        return $a;
    }
    return $obj;
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
        author          => scalarify($m->made_by),
        publisher       => scalarify($m->publisher),
        amazon_url      => $m->url,
        small_image     => $m->image('s'),
        medium_image    => $m->image('m'),
        large_image     => $m->image('l'),
    };

    # get more information through a different module
    my $a = Quelology::Config::amazon_net();
    my $res = $a->search(asin => $h->{asin});
    if ($res->is_success) {
        # TODO: be more robust
        my ($book) = $res->properties;
        if ($book->isbn) {
            $h->{ISBN} = $book->isbn;
        } else {
            $h->{ISBN} = $h->{asin} if $h->{asin} =~ /^\d/;
        }
        my $date = $book->publication_date // $book->ReleaseDate;
        my $year = (split /-/, $date)[0];
        $h->{publish_year} = $year if $year;
    }
    if ($h->{ISBN}) {
        my $i = isbn_extract($h->{ISBN});
        $h->{lang} = $i->{lang}[0] if $i;
    }

    return $h;
}

sub websearch {
    my ($self, $keywords) = @_;
    my $amazon = Quelology::Config::amazon();
    my $a_res  = $amazon->search(
        keywords    => $keywords,
        type        => 'Books',
    );
    return unless $amazon->is_success;
    my %root_seen;
    my @series;
    my @media;
    for ($a_res->collection) {
        if (my ($r) = $self->search({asin => $_->asin})) {
            if ($r->is_single) {
                push @media, $r;
            } else {
                next if exists $root_seen{$r->root_id};
                $root_seen{$r->root_id} = 1;
                push @series, $r->root;
            }
        } else {
            my $h = _hash_from_xml_amazon($_);
            my $r = $self->create($h);
            $r->attribute($h->{amazon_url});
            push @media, $r;
        }
    }
    return (\@series, \@media);
}

sub from_asin {
    my ($self, $asin) = @_;
    confess("No ASIN provided") unless defined($asin) && length $asin;
    my ($row) = $self->search({ asin => $asin });
    unless ($row) {
        my $a = Quelology::Config::amazon();
        my $m = $a->asin($asin);
        if ($m) {
            my $h = _hash_from_xml_amazon($m);
            $row = $self->create($h);
            $row->attribute($h->{amazon_url});
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
