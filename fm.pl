#!/usr/bin/perl

use Digest::MD5 qw(md5_hex);

print "Content-type: text/html\n\n";
print <<EO1;
<html>
<head>
	<script type="text/javascript" src="jquery-1.6.4.min.js"></script>
	<meta charset="UTF-8">
    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1" />
    <meta name="apple-itunes-app" content="app-id=741421960">
    <link rel="stylesheet" href="fm.css" type="text/css" media="screen, mobile" title="main">
    <link href="http://fonts.googleapis.com/css?family=Syncopate:400,700%7CMetrophobic" rel="stylesheet" type="text/css">
	<title>FiascoMobile Login</title>
</head>
<body>

<nav><img src="img/header.png" alt="FiascoMobile" /></nav>

<div id="IOSContainer">
<h1 id="title">Playsets...</h1>

<div class="playset loginForm">
EO1


# &envy;

@playset = split('\?', $ENV{HTTP_REFERER});

if (@playset[1]) {
	# print "Playset present... <br />";
	@playset = split('\?', $ENV{HTTP_REFERER});
	$playset = @playset[1];
	# print "playset: $playset<br />";
} else {
	# print "Eql?";
}

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
		open (HASHED, "</home/epistech/data/fiascomobile/validate.txt") or die ("Cannot open validation keys, contact support\n");
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
	if ($_[0] == "true") {print "<script>location.href='http://brooklynindiegames.com/fm/lns/$digest.html';</script></div>";}
}

sub ValidatedGo() {
	print "<script>document.getElementById('title').innerHTML = 'Success!';setTimeout(\"document.getElementById('footer').style.display = 'none'\", 35);</script>
	Thanks for logging in! Click the following link to go directly to the playsets, and then bookmark or add the resulting page to your Mobile Home Screen<br />
	</div><div id=\"playnow\" onClick=\"javascript:location.href='http://brooklynindiegames.com/fm/lns/$digest.html?$playset';\">LOG IN NOW</div>";
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
