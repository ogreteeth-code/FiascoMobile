#!/usr/local/bin/perl

use Digest::MD5 qw(md5_hex);

print "Content-type: text/html\n\n";
print <<EO1;
<html>
<head>
	<script type="text/javascript" src="jquery-1.6.4.min.js"></script>
	<meta charset="UTF-8">
    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1" />
    <link rel="stylesheet" href="fm.css" type="text/css" media="screen, mobile" title="main">
    <link href="http://fonts.googleapis.com/css?family=Syncopate:400,700%7CMetrophobic" rel="stylesheet" type="text/css">
	<title>Fiasco Mobile Login</title>
</head>
<body>

<nav><img src="img/header.png" alt="Fiasco Mobile" /></nav>

<div id="IOSContainer">
<h1 id="title">Playsets...</h1>

<div class="playset loginForm">
EO1

&envy;

#################

# read post from PayPal system and add 'cmd'
read (STDIN, $query, $ENV{'CONTENT_LENGTH'});
$query .= '&cmd=_notify-validate';

# post back to PayPal system to validate
use LWP::UserAgent;
$ua = new LWP::UserAgent;
$req = new HTTP::Request 'POST','https://www.paypal.com/cgi-bin/webscr';
# note: if you have SSL encryption Enabled, use <https://www.paypal.com/cgi-bin/webscr> above
$req->content_type('application/x-www-form-urlencoded');
$req->content($query);
$res = $ua->request($req);

# split posted variables into pairs
@pairs = split(/&/, $query);
$count = 0;
foreach $pair (@pairs) {
($name, $value) = split(/=/, $pair);
$value =~ tr/+/ /;
$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
$variable{$name} = $value;
$count++;
}

# assign posted variables to local variables
# note: additional IPN variables also available -- see IPN documentation
$item_name = $variable{'item_name'};
$receiver_email = $variable{'receiver_email'};
$item_number = $variable{'item_number'};
$invoice = $variable{'invoice'};
$a = $variable{'custom'};
$payment_status = $variable{'payment_status'};
$payment_gross = $variable{'payment_gross'};
$txn_id = $variable{'txn_id'};
$payer_email = $variable{'payer_email'};
$amount = $variable{'amount'};
$on0 = $variable{'option_name1'};
$os0 = $variable{'option_selection1'};
$status = $res->content;
$note = $variable{'memo'};


if ($res->is_error) {
# HTTP error
}
elsif ($res->content eq 'VERIFIED') {
# check the payment_status=Completed
# check that txn_id has not been previously processed
# check that receiver_email is an email address in your PayPal account
# process payment
# print to screen the following if the IPN POST was VERIFIED


print "content-type: text/plain\n\nOK\n";
print "<html><head><title>IPN Screendump</title></head>\n";
print "<body>your email address is <b>$payer_email</b>\n";
print "<br>you paid <b>$payment_gross</b>\n";
print "<br>you paid for <b>$item_number</b>\n";
print "<br>the color of your order was <b>$os0</b>\n";
print "<br>the value of custom was <b>$a</b>\n";
print "<br>the status was<b>$status</b>\n";
print "<br>the note said <b>$note</b>\n";
print "<br>the transaction id was <b>$txn_id</b>\n";
print "<br>the payment status was<b>$payment_status</b>\n";
print "</body></html>\n";


}
elsif ($res->content eq 'INVALID') {
# log for manual investigation
# print to screen the following if the IPN POST was INVALID

print "content-type: text/plain\n\nOK\n";

print "<html><head><title>IPN Screendump</title></head>\n";
print "<br>the status was<b>$status</b>\n";
print "</body></html>\n";


}
else {
# error
}


#################

if ($ENV{'REQUEST_METHOD'} eq "POST") {
	$checksum = 1;
	read(STDIN, $request, eval($ENV{'CONTENT_LENGTH'})) || die "Could not get query\n";

	@values = split('&', $request);
	foreach $val (@values) {
		# print "$val<br />\n"; #this line prints the split input for verification. You can use it commented for now.
		%splitval = (%splitval, split('=', $val));
		}

	if ($splitval{mailbox}) {
		$digest = md5_hex($splitval{mailbox});
		$validated = ValidateQ($digest);
	}
		
	if ($validated) {
		&ValidatedGo;
	}
}

if ($ENV{'REQUEST_METHOD'} eq "GET" && (length $ENV{'QUERY_STRING'}) == 32) {
	$digest = $ENV{'QUERY_STRING'};
	$validated = ValidateQ($digest);

	if ($validated) {
		&PreValidated($validated);
	}
} else {
	$digest = $ENV{'QUERY_STRING'};
}


if (!$validated) {
	&ValidateFail($digest);
}

sub ValidateQ($) {
	#print "Validating....";
	if ($digest) {
		open (HASHED, "<validate.txt") or die ("Cannot open validation keys, contact support\n");
			USER: while (<HASHED>) {
			if ($_ =~ m/$digest/) {
				#print "MATCH!";
				return true;
			}
		}
		close HASHED;
		$checksum = undef;
		return undef;
	}
}

sub PreValidated($) {
	if ($_[0] == "true") {print "<script>location.href='http://fiascomobile.ogreteeth.com/fiascomobile.html';</script></div>";}
}

sub ValidatedGo() {
	print "<script>document.getElementById('title').innerHTML = 'Success!';setTimeout(\"document.getElementById('footer').style.display = 'none'\", 35);</script>
	Thanks for logging in! Click the following link to go directly to the playsets, and then bookmark and/or add the resulting page to your iOS Home Screen<br />
	</div><div id=\"playnow\" onClick=\"javascript:location.href='http://fiascomobile.ogreteeth.com/fm.pl?$digest\';\">LOG IN NOW</div>";
}

sub ValidateFail($) {
	if ($digest) {
		print "\"$_[0]\" is an invalid key.";
	}

	if (!$validated) {
		print "<script>document.getElementById('title').innerHTML = 'Error!';</script>
		   <p>Either this is your first visit, or your information has not been found. Please correct any errors and try again.</p>
		   <p>Or if you do not have an account, please purchase a license.</p>
		   <p><form action=\"fm.pl\" method=\"post\">
		   <label for=\"mailbox\">Enter email address:</label>
		   <input name=\"mailbox\" type=\"email\" value=\"\"><input type=\"submit\"></form></p>\n\n</div>";
	}
}

sub envy() {
print "<pre>\n";
	while (($key, $value) = each(%ENV)) {
	print "$key => $value\n";
	}
print "</pre>\n";
}

print <<EO2;
<h1 id="footer" class="footer">...on the internet</h1>
</div>
</body>
</html>
EO2
