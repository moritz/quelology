package Quelology::Amazon::Item;
use 5.010;

# just a glorified hash really.
# A design sin, but convenient

sub AUTOLOAD {
    my $self = shift;
    my $name = $AUTOLOAD;
    $name =~ s/.*:://;
    $self->{$name};
}

sub new_from_dom {
    my ($class, $dom) = @_;
    my $self = bless {}, $class;
    $self->_init_from_dom($dom);
    $self;
}

sub _dom2hash {
    my %h;
    for (map @{$_->children}, @_) {
        unless (@{ $_->children}) {
            if (exists $h{ $_->type } ) {
                $h { $_->type } .= ', ' . $_->text;
#                no warnings 'uninitialized';
#                if (ref($h{ $_->type}) eq 'ARRAY') {
#                    push @{ $h{ $_->type } }, $_->text;
#                } else {
#                    $h{ $_->type } = [ $h{ $_->type }, $_->text ];
#                }
            } else {
                $h{ $_->type } = $_->text;
            }
        }
    }
    %h;
}


sub _init_from_dom {
    my ($self, $dom) = @_;
    %$self = _dom2hash $dom, $dom->at('ItemAttributes');
    $self->{Links} = {
        map { $_->at('Description')->text, $_->at('URL')->text }
            $dom->find('ItemLinks ItemLink')->each
    };
    delete $self->{Links} unless %{$self->{Links}};

    for my $thing (qw/SmallImage MediumImage LargeImage ListPrice PackageDimensions/) {
        if (my $d = $dom->at($thing)) {
            $self->{$thing} = { _dom2hash $d };
        }
    }
    {
        my %lang;
        for ($dom->find('Languages Language')->each) {
            my %l = _dom2hash $_;
            $lang{$l{Type}} = $l{Name};
        }
        $self->{Languages} = \%lang if %lang;
    }
}

sub DetailPageURL {
    my $self = shift;
    $self->{DetailPageURL} // "http://www.amazon.com/exec/obidos/ASIN/"
                              . $self->{ASIN} . "/quelology-20";

}

# just so that it needn't be triggered by AUTOLOAD
sub DESTROY {

}

1;
