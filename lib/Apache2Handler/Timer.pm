package Apache2Handler::Timer;

use strict;
use warnings;

use Time::HiRes qw/gettimeofday/;

use Apache2::Const -compile => qw(OK DECLINED);
use Apache2::Connection;
use Apache2::RequestRec;
use Apache2::RequestUtil;
use APR::Table;

sub handler {
    my $r = shift;

    $r->pnotes('start_time' => [gettimeofday()]);

    return Apache2::Const::OK;
}

1;

