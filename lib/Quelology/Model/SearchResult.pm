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
    my %method = (
        author  => 'a',
        series  => 't',
        title   => 't',
    );
    my %storage = (
        author  => 'authors',
        series  => 'series',
        title   => 'titles',
    );
    while (my $h = $hits->next) {
        my $type = $h->{type};
        my $method = $method{$h->{type}};
        push @{ $self->{ $storage{$h->{type}} } },
             $self->{schema}->$method->by_id( $h->{id} );
    }
    $self;
}

sub success {
    my $self = shift;
    $self->{authors} || $self->{series} || $self->{titles};
}

1;
