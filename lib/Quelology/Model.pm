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

__PACKAGE__->load_namespaces();

1;
