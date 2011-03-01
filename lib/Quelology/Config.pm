package Quelology::Config;
use 5.012;
use warnings;
use Exporter qw(import dbh);

our @EXPORT_OK = qw(config schema amazon amazon_net dbh);
use autodie;
use JSON::XS qw(decode_json);

use XML::Amazon::Cached;
use Net::Amazon;
use DBI;
use Quelology::Model;

my $conf = decode_json do {
    open my $file, '<:encoding(UTF-8)', 'config.json';
    my $content = do { local $/, <$file> };
    close $file;
    $content;
};

sub config { $conf };

sub dbh {
    my $dbh = DBI->connect(
        "dbi:Pg:dbname=$conf->{dbname};host=$conf->{dbhost}",
        $conf->{dbuser}, $conf->{dbpass},
        { RaiseError => 1, AutoCommit => 1},
    );
    $dbh->{pg_enable_utf8} = 1;
    $dbh;
}

sub amazon {
    state $a = XML::Amazon::Cached->new(
        token => config()->{amazon_token},
        sak   => config()->{amazon_secret_key},
        local => config()->{amazon_locale} // 'us',
    );
}

sub amazon_net {
    state $a = Net::Amazon->new(
        token       => config->{amazon_token},
        secret_key  => config->{amazon_secret_key},
        locale      => config->{amazon_locale},
        cache       => Cache::FileCache->new({ namespace => 'Net-Amazon' }),
    );
}

sub schema {
    Quelology::Model->connect(\&dbh);
}

1;
