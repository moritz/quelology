package Quelology::Model::ResultSet::Title;
use strict;
use 5.010;
use strict;
use Carp qw(confess);
use parent 'DBIx::Class::ResultSet';
use constant PAGE_SIZE => 100;

my $prefetch = { author_titles => 'author' };

sub by_id {
    my ($self, $id) = @_;
    # TODO: benchmark with and without prefetch
    my ($obj) = $self->search(
        { "me.id" => $id },
        { prefetch => $prefetch },
    );
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
        die "No title with asin '$asin' yet";
    }
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
    
    returns a resultset of titles that have publications in a different
    language than the title (which is a bad sign, because translations
    are supposed
    to be handled on the titles layer, not on the publications layer).

=cut

sub with_different_languages {
#    shift->search_rs({
#        'publications.lang' => { '<>' => undef },
#    }, {
#        join        => 'publications',
#        distinct    => 1,
#        having      => \'count(distinct(publications.lang)) > 1',
#    });
    shift->search(
        {
            'publications.lang' => { '<>', => \'me.lang' },
        },
        {
            join        => 'publications',
            prefetch    => ['publications', $prefetch],
        },
    );
}

sub authors {
    my $self = shift;
    $self->search_related('author_titles')->search_related('author', undef, { distinct => 1})
}

sub publications {
    my $self = shift;
    $self->search_related('publications');
}

sub with_translations {
    shift->search(undef,
        {
            join        => 'aliases',
            prefetch    => 'aliases',
            having      => \'count(aliases.*) > 1',
        },
    );
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

sub by_lang {
    my ($self, $lang, $page) = @_;
    $page //= 1;
    $self->search(
        { lang => $lang },
        {
            rows        => PAGE_SIZE,
            page        => $page,
            order_by    => 'title',
            prefetch    => $prefetch,
        },
    );
}

sub unknown_lang {
    my ($self, $page) = @_;
    $self->search(
        { lang => undef },
        {
            rows        => PAGE_SIZE,
            page        => $page,
            order_by    => 'title',
            prefetch    => $prefetch,
        },
    );
}

sub with_unconfirmed_pubs {
    my ($self, $page) = @_;
    $page //= 1;
    $self->search(
        undef,
        {
            join       => 'maybe_raw_publications',
            rows       => 100,
            page       => $page,
            order_by   => \'me.title',
            distinct   => 1,
            having     => \'COUNT(maybe_raw_publications.id) >= 1',
            prefetch   => { author_titles => 'author' },
        },
    );
}

sub random_series {
    my ($self, $count) = @_;
    $count //= 50;
    $self->threads->search(
        undef,
        {
            rows        => $count,
            order_by    => \'random()',
            prefetch    => $prefetch,
        },
    );
}

sub random_singles {
    my ($self, $count) = @_;
    $count //= 50;
    $self->singles->search(
        undef,
        {
            rows        => $count,
            order_by    => \'random()',
            prefetch    => $prefetch,
        },
    );
}

1;
