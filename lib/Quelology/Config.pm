package Quelology::Config;
use 5.012;
use warnings;
use Exporter qw(import dbh);

our @EXPORT_OK = qw(config schema amazon amazon_net dbh run_mode);
use autodie;
use JSON::XS qw(decode_json);

use XML::Amazon::Cached;
use Net::Amazon;
use DBI;
use Quelology::Model;

sub run_mode {
    $ENV{QUELOLOGY_RUNMODE} // $Quelology::RunMode // 'dev';
}

my $conf = decode_json do {
    open my $file, '<:encoding(UTF-8)', 'config.json';
    my $content = do { local $/, <$file> };
    close $file;
    $content;
};
unless (exists $conf->{run_mode()}) {
    die sprintf "No config for run mode '%' available (set with the"
                ."\nQUELOLOGY_RUNMODE environment variable (values dev, test or prod)",
                run_mode;
}

sub config {
    my $key = shift;
    $conf->{run_mode()}->{$key} // $conf->{$key}
};

sub dbh {
    my $dbh = DBI->connect(
        sprintf("dbi:Pg:dbname=%s;host=%s", config('dbname'), config('dbhost')),
        config('dbuser'), config('dbpass'),
        { RaiseError => 1, AutoCommit => 1},
    );
    $dbh->{pg_enable_utf8} = 1;
    $dbh;
}

use Memoize;
memoize('amazon');
memoize('amazon_net');

sub amazon {
    my $locale = shift // config('amazon_locale') // 'us';
     XML::Amazon::Cached->new(
        token => config('amazon_token'),
        sak   => config('amazon_secret_key'),
        local => $locale,
    );
}

sub amazon_net {
    my $locale = shift // config('amazon_locale') // 'us';
    Net::Amazon->new(
        token       => config('amazon_token'),
        secret_key  => config('amazon_secret_key'),
        locale      => $locale,
        cache       => Cache::FileCache->new({ namespace => 'Net-Amazon' }),
    );
}

sub schema {
    Quelology::Model->connect(\&dbh);
}

1;
