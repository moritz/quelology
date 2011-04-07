package Quelology::Model::ResultSet::Publication;
use strict;
use 5.012;
use Carp qw(confess);
use ISBN::Country qw/isbn_extract/;

use parent 'DBIx::Class::ResultSet';

sub by_id {
    my ($self, $id) = @_;
    my $obj = $self->find($id);
    die "No publication with id '$id' found" unless $obj;
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

sub _fixup_date {
    my $date = shift;
    my @d = split /-/, $date;
    push @d, 01, 01;
    join '-', @d[0..2];
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
            $h->{isbn} = $book->isbn;
        } else {
            $h->{isbn} = $h->{asin} if $h->{asin} =~ /^\d/;
        }
        my $date = $book->publication_date // $book->ReleaseDate;
        $h->{publication_date} = _fixup_date $date if $date;
    }
    if ($h->{isbn}) {
        my $i = isbn_extract($h->{isbn});
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
    my (@series, @titles, @pubs);
    my %root_seen;
    for ($a_res->collection) {
        if (my ($r) = $self->search({asin => $_->asin})) {
            if (my $t = $r->title_obj) {
                if ($t->is_single) {
                    push @titles, $t;
                } else {
                    next if exists $root_seen{$t->root_id};
                    $root_seen{$t->root_id} = 1;
                    push @series, $t->root;
                }
            } else {
                push @pubs, $r;
            }
        } else {
            die "Got no title from amazon - bad sign" unless $_->title;
            my $h = _hash_from_xml_amazon($_);
            my $r = $self->create($h);
            $r->attribute($h->{amazon_url});
            push @pubs, $r;
        }
    }
    return (\@series, \@titles, \@pubs);
}

sub from_asin {
    my ($self, $asin) = @_;
    confess("No ASIN provided") unless defined($asin) && length $asin;
    my ($row) = $self->search({ asin => $asin });
    unless ($row) {
        my $a = Quelology::Config::amazon();
        my $m = $a->asin($asin);
        if ($m) {
            die "Got no title from amazon - bad sign" unless $m->title;
            my $h = _hash_from_xml_amazon($m);
            $row = $self->create($h);
            $row->attribute($h->{amazon_url});
        } else {
            confess "Failed to retrieve medium with asin '$asin': neither in DB nor in amazon";
        }
    }
    # get the current ID from the database, so that relations work
    $row->discard_changes;
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

1;
