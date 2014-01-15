# Sample Bugzilla configuration
use warnings;
use JSON qw(decode_json);

# get deployed app info from Stackato
my $appinfo;
my $stackatoURL;
if (defined $ENV{VCAP_APPLICATION}){
  $appinfo = decode_json($ENV{VCAP_APPLICATION});
  $stackatoURL = $appinfo->{"uris"}[0];
} else {
  $stackatoURL = "bugzilla.stackato.local";
}

%answer = (
    ADMIN_EMAIL    => 'gerv@mozilla.org',
    ADMIN_PASSWORD => 'staccato',
    ADMIN_REALNAME => 'Gervase Markham',
    mailfrom       => 'bugzilla-daemon@example.com',
    smtpserver     => "smtp.example.com",
    urlbase        => 'http://' . $stackatoURL,
);
