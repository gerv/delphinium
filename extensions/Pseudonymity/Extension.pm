# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Extension::Pseudonymity;
use strict;
use base qw(Bugzilla::Extension);

# This code for this is in ./extensions/Pseudonymity/lib/Util.pm
use Bugzilla::Extension::Pseudonymity::Util;

our $VERSION = '0.01';

BEGIN {
    no warnings 'redefine';
    *Bugzilla::User::name  = \&_name;
    *Bugzilla::User::login = \&_login;
    *Bugzilla::User::email = \&_email;
}

# Source: http://www.flowers.org.uk/flowers/flower-common-names/list-of-flower-common-names/
my @pseudonyms = qw(
    User-ID-0-Is-Not-Valid
    Amaryllis
    Bellflower
    Bergamot
    Brodiaea
    Broom
    Buttercup
    Carnation
    Cockscomb
    Columbine
    Cornflower
    Daffodil
    Daisy
    Forgetmenot
    Foxglove
    Goldenrod
    Goosefoot
    Holly
    Hyacinth
    Larkspur
    Lavender
    Lilac
    Lily
    Lupin
    Marigold
    Mimosa
    Orchid
    Peony
    Primrose
    Rose
    Snapdragon
    Speedwell
    Sunflower
    Sweetpea
    Tansy
    Tazetta
    Thistle
    Throatwort
    Tulip
    Wormwood
    Yarrow
);

sub get_pseudonym {
    my $userid = $_[0]->id;

    if ($userid < scalar(@pseudonyms)) {
        return $pseudonyms[$userid];
    }
    else {
        # Not enough pseudonyms supplied
        return $userid;
    }
}

sub _name {
    my $nym = get_pseudonym($_[0]);
    
    return "Participant " . $nym;
}

sub _login {
    my $nym = get_pseudonym($_[0]);
    
    return lc($nym) . '@pseudonymous.invalid';
}

# Need to return the real email address so we can still send email
sub _email {
    $_[0]->{login_name} . Bugzilla->params->{'emailsuffix'};
}

__PACKAGE__->NAME;
