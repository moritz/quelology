package Quelology::Test::Setup;
use strict;
use warnings;
use autodie qw/system/;

BEGIN {
    $Quelology::RunMode = 'test';
}

our @EXPORT = qw/init_db/;
use Exporter qw/import/;

sub init_db {
    # TODO: read that info from the config file
    system('psql quelology-test -h localhost -U quelology-dev < t/db-snapshot.sql > /dev/null 2>&1');
}

1;
