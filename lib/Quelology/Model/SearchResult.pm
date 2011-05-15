package Quelology::Model::SearchResult;
use Mojo::Base -base;
has [qw/terms schema authors titles series/];

sub new {
    my ($class, %params) = @_;
    my $self = bless {}, $class;;
    $self->_init(\%params);
}

sub _init {
    my ($self, $params) = @_;
    $self->{$_} = $params->{$_} for qw/terms schema/;
    my $hits = $params->{hits};
    my %series_seen;
    my $schema = $self->{schema};
    for my $section (qw/author title series/) {
        my $hits = $params->{$section};
        next unless $hits;
        while (my $h = $hits->next) {
            given ($section) {
                when ('author') {
                    push @{ $self->{authors} }, $schema->a->by_id( $h->{id} );
                }
                when ('title') {
                    if ($h->{series_id}) {
                        $series_seen{$h->{series_id}} = undef;
                    }
                    push @{ $self->{titles} }, $schema->t->by_id( $h->{id} );
                }
                when ('series') {
                    unless (exists $series_seen{$h->{id}}) {
                        push @{ $self->{series} }, $schema->t->by_id( $h->{id} );
                    }
                }
            }
        }
    }
    $self;
}

sub success {
    my $self = shift;
    $self->{authors} || $self->{series} || $self->{titles};
}

1;
