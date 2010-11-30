package XML::Amazon::Cached;
use strict;
use warnings;
use parent 'XML::Amazon';
use Cache::FileCache;
use mro qw/c3/;

my $cache = Cache::FileCache->new({
        namespace => 'XML-Amazon-Cached',
    });

sub asin {
    my ($self, $asin) = @_;
    my $result = $cache->get($asin);
    if (defined $result) {
        return $result;
    }

    $result = $self->next::method($asin);
    $cache->set($asin, $result);
    $result;
}

1;
