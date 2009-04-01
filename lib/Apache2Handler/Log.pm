package Apache2Handler::Log;

use strict;
use warnings;

use Time::HiRes qw/tv_interval time/;
use Apache2::Const -compile => qw(OK DECLINED);
use Apache2::RequestRec;
use Apache2::RequestUtil;
use Apache2::Connection;
use APR::Table;
use DBIx::DWIW;

sub handler {
    my $r = shift;

    my $host = '';
    my $db = '';
    my $user = '';
    my $pass = '';

    my $DB = DBIx::DWIW->Connect(Host => $host, DB => $db, User => $user, Pass => $pass);

    $DB->Execute("INSERT INTO `http_request_log` 
         (`url`, `args`, `useragent`, `ip`, `referrer`, 
         `ptime`, `dbtime`, `http_code`, `bytes_sent`, `logtime`) VALUES
        (?, ?, ?, INET_ATON(?), ?, ?, ?, ?, ?, UTC_TIMESTAMP())",
        $r->uri, $r->args() || '', $r->headers_in->{'User-Agent'}, $r->connection->remote_ip,
        $r->headers_in->{Referer} || '', tv_interval($r->pnotes('start_time')), 0.0, 
        $r->status, $r->bytes_sent);

    return Apache2::Const::OK;
}

1;


