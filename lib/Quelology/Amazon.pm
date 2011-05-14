package Quelology::Amazon;
use Mojo::Base -base;
has 'token';
has 'secrit';
has 'associate' => 'quelology-20';
has 'locale'    => 'us';

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
    my %req = (
        %base_request,
        Operation   => 'ItemLookup',
        ItemId      => $opts{asin},
    );
    my $dom = $self->_do_request(\%req);
#    say $dom->inner_xml;
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
    return Quelology::Amazon::Response->new_from_dom($self->_do_request(\%req));
}

my %locale2tld = (
    ca  => 'ca',
    de  => 'de',
    fr  => 'fr',
    jp  => 'jp',
    uk  => 'co.uk',
    us  => 'com',
);

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
    if ($dom->at('IsValid')->text ne 'True') {
        die "Error during request (TODO: extract error from response)";
    };
    $dom;
}

1;
