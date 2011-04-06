package Quelology::Test::Setup;
use strict;
use warnings;
use autodie qw/system/;
use Quelology::Config qw/config/;

BEGIN {
    $Quelology::RunMode = 'test';
}

our @EXPORT = qw/init_db/;
use Exporter qw/import/;

sub init_db {
    # TODO: read that info from the config file
    my ($user, $dbname, $host) = map config($_), qw/dbuser dbname dbhost/;

    system("psql $dbname -h $host -U $user < t/db-snapshot.sql > /dev/null 2>&1");
}

1;
