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
    if ($field eq "bug_status") {
        unless (Bugzilla->user->in_group('moderators')) {
            push @$priv_results, PRIVILEGES_REQUIRED_EMPOWERED;
        }
    }
}

__PACKAGE__->NAME;
