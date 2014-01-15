#!/usr/bin/env plackup
# -*- Mode: perl; indent-tabs-mode: nil -*-
# vim: set filetype=perl expandtab tabstop=4 shiftwidth=4:
#
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
#
# The Original Code is the Bugzilla Bug Tracking System.
#
# The Initial Developer of the Original Code is Hans Dieter Pearcey. 
# Portions created by the Initial Developer are Copyright (C) 2010 the
# Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Hans Dieter Pearcey <hdp@cpan.org>
#   Max Kanat-Alexander <mkanat@bugzilla.org>

use strict;
use warnings;
use File::Basename;
use lib dirname(__FILE__);
use Bugzilla::Constants ();
use lib Bugzilla::Constants::bz_locations()->{'ext_libpath'};

# This is an array of regular expressions describing paths that
# can be served statically by plackup if it is asked to do so.
use constant ALLOWED_STATIC => qw(
    docs
    extensions/[^/]+/web
    graphs
    images
    js
    skins
);

# All Plack modules must be loaded before any Bugzilla modules,
# in case they want to override built-in Perl functions.
# For example, WrapCGI loads CGI::Compile, which overrides
# "exit", and Bugzilla won't work properly unless exit has
# already been overridden.
#
# Bugzilla::Constants doesn't call "exit", so it can safely
# be loaded above.
use Plack;
use Plack::Builder;
use Plack::App::WrapCGI;
use Plack::App::URLMap;

use Bugzilla::Install::Requirements qw(compilable_cgis);

BEGIN { $ENV{PLACK_VERSION} = 'Plack/' . Plack->VERSION; }

builder {
    enable 'Plack::Middleware::ContentLength';

    my $cgi_path = Bugzilla::Constants::bz_locations->{'cgi_path'};

    my $static_paths = join('|', ALLOWED_STATIC);
    enable 'Static',
        path => qr{.*/($static_paths)/},
        root => $cgi_path;

    my $map = Plack::App::URLMap->new;
    no warnings 'redefine';
    local *lib::import = sub {};
    use warnings;
    foreach my $cgi (compilable_cgis()) {
        my $base_name = basename($cgi);
        my $app = Plack::App::WrapCGI->new(script => $cgi)->to_app;
        my $wrapped = sub {
            # These CGI variables aren't correct sometimes, unless
            # we fix them here.
            Bugzilla::init_page();
            my $res = $app->(@_);
            Bugzilla::_cleanup();
            return $res;
        };
        $map->mount('/' => $wrapped) if $base_name eq 'index.cgi';
        $map->mount("/$base_name" => $wrapped);
    }
    $map->to_app;
};
