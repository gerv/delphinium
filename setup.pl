use strict;
use warnings;

use ActiveState::Run qw(run);
use version;

# Create an "answer" file for checksetup.pl to configure MySQL
# and to setup the initial administrator account.
our %answer;
do 'myconfig.pl';

my($user,$password,$host,$port,$name) = $ENV{MYSQL_URL} =~ m{mysql://(.+?):(.+?)\@(.+?):(\d+?)/(.*?)$}
    or die "MySQL service not configured";

%answer = (
    NO_PAUSE       => 1,
    db_driver      => 'mysql',
    db_host        => $host,
    db_name        => $name,
    db_pass        => $password,
    db_port        => $port,
    db_user        => $user,
    webservergroup => 'stackato',

    mail_delivery_method => 'SMTP',
    %answer
);

# Make sure urlbase ends with a slash
$answer{urlbase} =~ s,(.*[^/])$,$1/,;

my $answer = "checksetup.answer";
open my $fh, ">", $answer or die "Can't write '$answer': $!";
print $fh qq(\$answer{$_} = "\Q$answer{$_}\E";\n) for sort keys %answer;
close $fh;

# First run of checksetup.pl will update localconfig file.
# Second run will actually configure the database and
# create the admin user.
run("$^X ./checksetup.pl --verbose $answer") for 1..2;
