#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use lib dirname(__FILE__);
use Bugzilla::Constants;
my $cgi_dir = bz_locations()->{'cgi_path'};

my @args = @ARGV;
if ($ENV{PLACK_ENV} and $ENV{PLACK_ENV} eq 'development') {
    # XXX Plack daemonizes when you add this argument, which
    # doesn't work under mod_fcgid
    # push(@args, '-R', "$cgi_dir,$cgi_dir/Bugzilla,$lib_dir");
}
else {
    push(@args, '--env=deployment');
}

my $psgi = "$cgi_dir/app.psgi";
exec('plackup', '--server=FCGI', '--host=localhost', @args, $psgi)
    or die "Couldn't exec $psgi: $!";
