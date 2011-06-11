package Quelology::Config;
use 5.010;
use strict;
use warnings;
use Exporter qw(import dbh);

our @EXPORT_OK = qw(config schema amazon dbh run_mode);
use autodie;
use JSON::XS qw(decode_json);

use DBI;
use Quelology::Model;
use Quelology::Amazon;

sub run_mode {
    $ENV{QUELOLOGY_RUNMODE} // $Quelology::RunMode // 'dev';
}

my $dir = $ENV{QUELOLOGY_HOME} || '.';
$ENV{MOJO_HOME} //= "$dir/web/";

my $conf = decode_json do {
    open my $file, '<:encoding(UTF-8)', "$dir/config.json";
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
    say "Database: ", config('dbname');
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
memoize('schema');

sub amazon {
    Quelology::Amazon->new(
        token   => config('amazon_token'),
        secrit  => config('amazon_secret_key'),
        locale  => 'us',
        cache_dir => 'data/amazon-xml',
    );
}

sub schema {
    Quelology::Model->connect(\&dbh);
}

1;
