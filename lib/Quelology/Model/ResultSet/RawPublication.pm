package Quelology::Model::ResultSet::RawPublication;
use strict;
use 5.012;
use Carp qw(confess);
use ISBN::Country qw/isbn_extract/;
use Locales;

my $locales = Locales->new;

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

sub _isbn_to_lang {
    my $i = isbn_extract(shift);
    return $i->{lang}[0] if $i;
    undef;
}

sub _guess_lang {
    my $h = shift;
    if ($h->languages) {
        my $l = $h->languages;
        my $guess = $l->{Published} // $l->{Unknown};
        return $locales->get_code_from_language($guess) if defined $guess;
        use Data::Dumper;
        print Dumper $l;
    }
    _isbn_to_lang($h->isbn);
}

sub _hash_from_xml_amazon {
    my $m = shift;
    # TODO: handle publisher and author as relations
    my $h = {
        asin                => $m->asin,
        title               => $m->title,
        isbn                => $m->isbn,
        authors             => $m->author,
        amazon_url          => $m->detailpageurl,
        small_image         => $m->smallimage->{url},
        small_image_width   => $m->smallimage->{width},
        small_image_height  => $m->smallimage->{height},
        medium_image        => $m->mediumimage->{url},
        medium_image_width  => $m->mediumimage->{width},
        medium_image_height => $m->mediumimage->{height},
        large_image         => $m->largeimage->{url},
        large_image_width   => $m->largeimage->{width},
        large_image_height  => $m->largeimage->{height},
        publication_date    => _fixup_date($m->publicationdate // $m->releasedate),
        publisher           => $m->publisher,
    };

    return $h;
}

sub websearch {
    my ($self, $keywords) = @_;
    my $amazon = Quelology::Config::amazon();
    my $a_res  = $amazon->search(
        keywords    => $keywords,
        type        => 'Books',
    );
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
        my $am = Quelology::Config::amazon();
        my $m = $am->asin(asin => $asin);
        if ($m) {
            die "Got no title from amazon - bad sign" unless $m->title;
            my $h = _hash_from_xml_amazon($m);
            $row = $self->create($h);
            $row->attribute($row->amazon_url);
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
