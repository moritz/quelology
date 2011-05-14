package Quelology::Model;
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

my $ks;
my $query_parser;

# TODO: make paths more robust
sub search {
    my ($self, $terms) = @_;
    $ks //= KinoSearch::Search::IndexSearcher->new(
        index => 'data/search-index/common/',
    );
    $query_parser //= KinoSearch::Search::QueryParser->new(
        schema          => $ks->get_schema,
        default_boolop  => 'AND',
    );
    my $hits = $ks->hits(
        query       => $query_parser->parse($terms),
        offset      => 0,
        num_wanted  => 100,
    );
    Quelology::Model::SearchResult->new(
        hits    => $hits,
        terms   => $terms,
        schema  => $self,
    );
}

use Data::Page;

sub amazon_search {
    my ($self, $q, $page) = @_;
    my $res = Quelology::Config::amazon()->search(
        page        => $page,
        keywords    => $q,
    );

    my $page = Data::Page->new;
    $page->total_entries($res->total_results);
    $page->entries_per_page(10);
    $page->current_page($page);

    my @pubs;
    for (@{$res->items}) {
        my $asin = $_->asin // $_->isbn;
        if (defined $asin && (my $db_pub = $self->p->find({ asin => $asin },
                        { prefetch => { title => {author_title => 'author' }}}))) {
            push @pubs, $db_pub;
        } else {
            push @pubs, $self->rp->import_from_amazon_item($_);
        }
    }
    return ($page, \@pubs);
}

__PACKAGE__->load_namespaces();

1;
