# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Extension::Delphinium::Config;
use strict;
use warnings;

use Bugzilla::Config::Common;

our $sortkey = 5000;

sub get_param_list {
    my ($class) = @_;

    my @param_list = (
    {
        name => 'login_name_queue',
        type => 't',
        default => join(", ", qw(
            Waxflower
            Bloom
            Buckthorn
            Marigold
            Gillyflower
            Sage
            Speedwell
            Nerine
            Broom
            Lily
            Tansy
            Marguerite
            Watsonia
            Thistle
            Freesia
            Cornflower
            Yarrow
            Sunflower
            Phlox
            Tuberose
            Holly
            Fern
            Godetia
            Curcuma
            Carnation
            Eucalyptus
            Monkshood
            Tazetta
            Myrtle
            Lupin
            Lumex
            Stonecrop
            Peony
            Rose
            Dahlia
            Bergamot
            Bouvardia
            Goosefoot
            Foxtail
            Saponaria
            Gerbera
            Lilac
            Dill
            Tulip
            Heather
            Allium
            Safflower
            Gentian
            Brodiaea
            Telstar
            Orchid
            Larkspur
            Foxglove
            Gardenia
            Mimosa
            Ivy
            Statice
            Daisy
            Masterwort
            Windflower
            Hydrangea
            Poinsettia
            Columbine
            Sugarbush
            Tracelium
            Amaryllis
            Snapdragon
        )),
    },
    );
    return @param_list;
}

1;
