use strict;
use warnings;
{
    package FakeEval;
    require Exporter;
    our @ISA        = qw/Exporter/;
    our @EXPORT_OK  = qw/eval/;

    sub eval {
        die "FOUND AN EVAL: $_[0]";
        CORE::eval $_[0];
    }

    sub import {
        my $pkg = shift;
        return unless @_;
        my $sym = shift;
        my $where = 'CORE::GLOBAL';
        $pkg->export($where, $sym, @_);
    }
}
1;
