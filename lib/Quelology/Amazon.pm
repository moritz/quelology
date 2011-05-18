package Quelology::Amazon;
use Mojo::Base -base;
has 'token';
has 'secrit';
has 'associate' => 'quelology-20';
has 'locale'    => 'us';
has 'cache_dir';

use Quelology::Amazon::Response;
use Mojo::UserAgent;
use Mojo::ByteStream qw/b/;
use POSIX qw/strftime/;
use Digest::SHA qw/hmac_sha256_base64/;

my %base_request = (
    Services        => 'AWSECommerceService',
    Version         => '2010-11-01',
    ResponseGroup   => 'Images,ItemAttributes',
);

sub new {
    my ($class, %opts) = @_;
    bless \%opts, $class;
}

sub asin {
    my ($self, %opts) = @_;
    my $asin = $opts{asin};
    my $cache_file;
    if ($self->cache_dir) {
        $cache_file = $self->cache_dir . '/' . $asin . '.xml';
        if (open my $f, '<:encoding(UTF-8)', $self->cache_dir . '/' . $asin . '.xml') {
            my $contents = do { local $/; <$f> };
            close $f;
            my $i = Quelology::Amazon::Item->new_from_dom(
                Mojo::DOM->new->parse($contents)
            );
            $i->{ASIN} = $opts{asin};
            return $i;
        }
    };
    my %req = (
        %base_request,
        Operation   => 'ItemLookup',
        ItemId      => $asin,
    );
    my $dom = $self->_do_request(\%req);
#    say $dom->inner_xml;
    if ($cache_file) {
        use autodie;
        open my $f, '>:encoding(UTF-8)', $cache_file;
        print { $f } $dom->to_xml;
        close $f;
    }
    _check_error($dom);
    my $i = Quelology::Amazon::Item->new_from_dom($dom);
    # it is both logical and annoying that amazon skips the ASIN
    # in the response of requests for a particular ASIN. So fix it up:
    $i->{ASIN} = $opts{asin};
    return $i;
}

sub search {
    my ($self, %opts) = @_;
    my %req = (
        %base_request,
        Operation       => 'ItemSearch',
        SearchIndex     => $opts{searchindex} // 'Books',
        Keywords        => $opts{keywords} // die("argument 'keywords' missing"),
        ItemPage        => $opts{page} // 1,
    );
    my $dom = $self->_do_request(\%req);
    _check_error($dom);
    return Quelology::Amazon::Response->new_from_dom($dom);
}

my %locale2tld = (
    ca  => 'ca',
    de  => 'de',
    fr  => 'fr',
    jp  => 'jp',
    uk  => 'co.uk',
    us  => 'com',
);

sub _check_error {
    my $dom = shift;
    if ($dom->at('ItemAttributes')) {
        # even if we got an error, it can'be very fatal.
        return;
    }
    if (my $ed = $dom->at('Error')) {
        if ($ed->at('Code')->text eq 'AWS.ECommerceService.NoExactMatches') {
            return;
        }
        say $dom->at('Message')->text if $ENV{QUELOLOGY_DEBUG_AMAZON};
        die "Error during request: " . $ed->at('Message')->text;
    };

}

sub _do_request {
    my ($self, $req) = @_;
    $req->{Timestamp}      = strftime('%Y-%m-%dT%H:%M:%SZ', gmtime);
    $req->{AWSAccessKeyId} = $self->token;
    my $domain = "ecs.amazonaws." .$locale2tld{$self->locale};
    my @param  = map { "$_=" . b($req->{$_})->url_escape } sort keys %$req;

    my $string_to_sign = "GET\n$domain\n/onca/xml\n" . join('&', @param);
    my $signature = hmac_sha256_base64($string_to_sign, $self->secrit);
    $signature .= '=' while length($signature) % 4;
    push @param, "Signature=" . b($signature)->url_escape;

    my $url = "http://$domain/onca/xml?" . join '&', @param;
    my $response = Mojo::UserAgent->new->get($url)->res;
    my $dom = $response->dom;
    $dom;
}

1;
