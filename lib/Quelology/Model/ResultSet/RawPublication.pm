package Quelology::Model::ResultSet::RawPublication;
use strict;
use 5.010;
use strict;
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
    push @d, qw/01 01/;
    my $d = join '-', @d[0..2];
    if ($d =~ /^\d{4}-\d\d-\d\d$/) {
        return $d;
    }
    undef;
}

sub _isbn_to_lang {
    my $i = isbn_extract(shift);
    return $i->{lang}[0] if $i;
    undef;
}

sub _guess_lang {
    my $h = shift;
    if ($h->Languages) {
        my $l = $h->Languages;
        my $guess = $l->{Published} // $l->{Unknown};
        return $locales->get_code_from_language($guess) if defined $guess;
        use Data::Dumper;
        print Dumper $l;
    }
    my $is = $h->ISBN // $h->ASIN;
    _isbn_to_lang($is) if $is;
    undef;
}

sub _frob_binding {
    my $b = lc shift;
    # TODO: get data from database somehow
    my %known = (
        paperback   => 1,
        hardcover   => 1,
        pamphlet    => 1,
        digest      => 1,
        ebook       => 1,
        audio       => 1,
        video       => 1,
    );
    return $b if $known{$b};
    undef;
}

sub _hash_from_xml_amazon {
    my $m = shift;
    # TODO: handle publisher and author as relations
    my $h = {
        asin                => $m->ASIN,
        title               => $m->Title,
        isbn                => $m->ISBN,
        authors             => $m->Author,
        amazon_url          => $m->DetailPageURL,
        publication_date    => _fixup_date($m->PublicationDate // $m->ReleaseDate),
        publisher           => $m->Publisher,
        pages               => $m->NumberOfPages,
        binding             => _frob_binding($m->Binding),
        lang                => _guess_lang($m),
    };
    for (qw/Small Medium Large/) {
        my $method = $_ . 'Image';
        if ($m->$method) {
            $h->{lc($_) . '_image'}        = $m->$method->{URL};
            $h->{lc($_) . '_image_width'}  = $m->$method->{Width};
            $h->{lc($_) . '_image_height'} = $m->$method->{Height};
        }
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

sub by_asin {
    my ($self, $asin) = @_;
    confess("No ASIN provided") unless defined($asin) && length $asin;
    my ($row) = $self->search({ asin => $asin });
    die "ASIN <$asin> not in DB" unless $row;
    $row;
}

sub import_from_amazon_item {
    my ($self, $ai) = @_;
    if ($ai->ASIN && (my $existing = $self->find({asin => $ai->ASIN}))) {
        return $existing;
    }
    my $row = $self->create(_hash_from_xml_amazon($ai));
    $row->discard_changes;
    $row->attribute($row->amazon_url);
    $row;
}

sub import_by_asin {
    my ($self, $asin) = @_;
    my $am = Quelology::Config::amazon();
    my $m = $am->asin(asin => $asin);
    my $row;
    if ($m) {
        return $self->import_from_amazon_item($m);
    } else {
        confess "Failed to retrieve medium with asin '$asin': neither in DB nor in amazon";
    }
}

sub import_from_xisbn_attrs {
    my ($self, $attrs) = @_;
    if (length($attrs->{lang}) > 2) {
        die "Please preprocess xisbn data (with package Quelology::XISBNImport) before passing it to import_from_xisbn_attrs)";
    }
    my $h = {
        asin                => $attrs->{isbn}, # TODO: make sure it's ISBN-10
        title               => $attrs->{title},
        isbn                => $attrs->{isbn},
        authors             => $attrs->{author},
        publication_date    => _fixup_date($attrs->{year}),
        publisher           => $attrs->{publisher},
        binding             => $attrs->{form},
        lang                => $attrs->{lang},
    };
    $self->result_source->schema->txn_do(sub {
            my $new = $self->create($h);
            $new->create_related('attributions', {
                    name    => 'worldcat',
                    url     => $attrs->{url},
            });
            return $new;
    });
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
