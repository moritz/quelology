package Quelology::Model;
use 5.010;
use Carp qw(confess);
use KinoSearch::Search::IndexSearcher;
use Quelology::Model::SearchResult;

use parent qw/DBIx::Class::Schema/;

sub a {
    shift->resultset('Author');
}

sub t {
    shift->resultset('Title');
}

sub p {
    shift->resultset('Publication');
}

sub rp {
    shift->resultset('RawPublication');
}

sub login {
    my ($self, $username, $password) = @_;
    my $user = $self->resultset('UserLogin')->find({name => $username});
    unless ($user) {
        return;
    }
    $user->authenticate($password);
}

use Data::Page;

# TODO: make paths more robust
sub search {
    my ($self, $terms, $page) = @_;
    $page //= 1;
    state %ks;
    state %query_parser;

    my %res;
    for my $section (qw/author title series/) {
        $ks{$section} //= KinoSearch::Search::IndexSearcher->new(
            index => "data/search-index/$section/",
        );
        $query_parser{$section} //= KinoSearch::Search::QueryParser->new(
            schema          => $ks{$section}->get_schema,
            default_boolop  => 'AND',
        );
        my $hits = $ks{$section}->hits(
            query       => $query_parser{$section}->parse($terms),
            offset      => 100 * ($page - 1),
            num_wanted  => 100,
        );
        $res{$section} = $hits;
    }
    return Quelology::Model::SearchResult->new(
        terms   => $terms,
        schema  => $self,
        %res,
    );
}


sub amazon_search {
    my ($self, $q, $page) = @_;
    my $res = Quelology::Config::amazon()->search(
        page        => $page,
        keywords    => $q,
    );

    my $pager = Data::Page->new;
    $pager->total_entries($res->total_results);
    $pager->entries_per_page(10);
    $pager->current_page($page);

    my @pubs;
    for (@{$res->items}) {
        my $asin = $_->ASIN // $_->ISBN;
        if (defined $asin && (my $db_pub = $self->p->find({ asin => $asin },
                        { prefetch => { title_obj => {author_titles => 'author' }}}))) {
            push @pubs, $db_pub;
        } else {
            push @pubs, $self->rp->import_from_amazon_item($_);
        }
    }
    return ($pager, \@pubs);
}

__PACKAGE__->load_namespaces();

1;
