package Quelology::Amazon::Response;
use Mojo::Base -base;

use Quelology::Amazon::Item;

has 'total_results';
has 'result_pages';
has 'items';

sub new_from_dom {
    my ($class, $dom) = @_;
    my $self = bless {}, $class;
    $self->_init_from_dom($dom);
    $self;
}

sub _init_from_dom {
    my ($self, $dom) = @_;
    $self->total_results($dom->at('totalresults')->text);
    $self->result_pages ($dom->at('totalpages')  ->text);
    $self->items([map Quelology::Amazon::Item->new_from_dom($_),
                    $dom->find('items item')->each]);
}


1;
