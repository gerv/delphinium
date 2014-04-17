# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Extension::Delphinium;
use strict;
use base qw(Bugzilla::Extension);

# This code for this is in ./extensions/Delphinium/lib/Util.pm
use Bugzilla::Extension::Delphinium::Util;

use Bugzilla::Constants;
use Bugzilla::Util;
use Bugzilla::Config qw(SetParam write_params);

our $VERSION = '0.01';

# See the documentation of Bugzilla::Hook ("perldoc Bugzilla::Hook" 
# in the bugzilla directory) for a list of all available hooks.
sub install_update_db {
    my ($self, $args) = @_;

}

sub bug_check_can_change_field {
    my ($self, $args) = @_;
    my ($bug, $field, $old_value, $new_value, $priv_results)
                     = @$args{qw(bug field old_value new_value priv_results)};

    # Only moderators may close or reopen issues
    if ($field =~ /bug_status|resolution|dup_id/) {
        unless (Bugzilla->user->in_group('moderators')) {
            push @$priv_results, PRIVILEGES_REQUIRED_EMPOWERED;
        }
    }
}

sub modify_new_account {
    my ($self, $args) = @_;
    my $cgi = $args->{'cgi'};

    # Try and avoid false triggers of this code, which wastes a username
    if (!defined($cgi->param('email'))
        || !defined($cgi->param('token'))
        || defined($cgi->param('password'))
        || defined($cgi->param('GoAheadAndLogIn')))
    {
        return;
    }

    # This code gets run when the user enters their email address to
    # start the account creation process. So a username allocated may not
    # actually come to exist, if the user never completes the process.
    my @logins = split(/[\s,]+/, Bugzilla->params->{'login_name_queue'});
    my $login;
    
    if (scalar(@logins)) {
        $login = shift(@logins);
        SetParam('login_name_queue', join(", ", @logins));
        write_params();
    }
    else {
        # Any random string will do as a backup
        $login = generate_random_password();
    }
    
    $cgi->param('login', $login);
}

sub config_add_panels {
    my ($self, $args) = @_;
    
    my $modules = $args->{panel_modules};
    $modules->{Delphinium} = "Bugzilla::Extension::Delphinium::Config";
}



__PACKAGE__->NAME;
