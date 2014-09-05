#!/usr/local/bin/perl

use Digest::MD5 qw(md5_hex);

print "Content-type: text/html\n\n";
print <<EO1;
<html>
<head>
	<script type="text/javascript" src="jquery-1.6.4.min.js"></script>
	<meta charset="UTF-8">
    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1" />
    <link rel="stylesheet" href="../fm.css" type="text/css" media="screen, mobile" title="main">
    <link href="http://fonts.googleapis.com/css?family=Syncopate:400,700%7CMetrophobic" rel="stylesheet" type="text/css">
	<title>FiascoMobile Admin</title>
</head>
<body>

<nav><img src="../img/header.png" alt="Fiasco Mobile" /></nav>

<div id="IOSContainer">
<h1 id="title">Ad-Mi-Ni-Strate!</h1>

<div class="playset loginForm">
EO1

# &debugMode;

if ($ENV{'REQUEST_METHOD'} eq "POST" && validateDomain($ENV{'HTTP_REFERER'}) eq true) {
	$checksum = 1;
	read(STDIN, $request, eval($ENV{'CONTENT_LENGTH'})) || die "Could not get query\n";

	@values = split('&', $request);
	foreach $val (@values) {
		# print "$val<br />\n"; #this line prints the split input for verification. You can use it commented for now.
		%splitval = (%splitval, split('=', $val));
		}

	if ($splitval{passphrase}) {
		$digest = md5_hex($splitval{passphrase});
		$validated = ValidateQ($digest);
	}

	if ($splitval{mailbox}) {
		$digest = md5_hex($splitval{mailbox});
		$validated = AddNewUser($splitval{mailbox}, $digest);
	}

	if($splitval{AAA111}) {
		$digest = md5_hex($splitval{AAA111});
        $valone = AddNewUser($splitval{AAA111}, $digest);
	}
}

if ($validated) {
	&ValidatedGo;
} elsif ($valone) {
	&OneEntry;
} else {
	&ValidateFail;
}

sub ValidateQ($) {
	#print "Validating....";
	if ($digest) {
		open (HASHED, "</home/epistech/data/fiascomobile/fmadmin.txt") or die ("Cannot open validation keys, contact support\n");
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

sub VerifyAdd($) {
	#print "Validating....";
	if ($_[0]) {
		open (HASHED, "</home/epistech/data/fiascomobile/validate.txt") or die ("Cannot open validation keys, contact support\n");
			while (<HASHED>) {
				if ($_ =~ m/$_[0]/) {
					print "VALIDATED</p>";
					close HASHED;
					return true;
				}
			}
		print "FAILED</p>";
		close HASHED;
		return undef;
	}
}



sub AddNewUser($$) {
	if (length ($_[1]) == 32) {
		print "<p>Adding user $_[0]</p>\n";
		open (HASHED, ">>/home/epistech/data/fiascomobile/validate.txt") or die ("Cannot open validation keys, contact support\n");
		print HASHED "\n" . $_[0] . ":" . $_[1];
		close HASHED;
		$newuser = $_[1];
		return true;	
	}
	
}

sub ValidatedGo() {
	if ($newuser) {
		print "<p>Looks like you just added a new user... verifying...";
		if (VerifyAdd($newuser)) {
			print "<p>Adding Link...";
			system "ln -s ../fiascomobile.php ../lns/$newuser.php";
			if (stat "../lns/$newuser.php") {
				print 'linked!</p>';
			}
		}
	}
	print "<p>Enter the new user's email address...</p>
		<p><form action=\"fmadmin.pl\" method=\"post\">
		<label for=\"mailbox\">Email Address:</label>
		<input name=\"mailbox\" type=\"email\" value=\"\"><input type=\"submit\"></form></p>\n\n</div>";

}
sub OneEntry() {
        if ($newuser) {
                print "<p>Thanks for redeeming a coupon code....verifying...";
                if (VerifyAdd($newuser)) {
                        print "<p>Linking...";
                        system "ln -s ../fiascomobile.php ../lns/$newuser.php";
                        if (stat "../lns/$newuser.php") {
                                print 'linked!</p>';
                        }
                print "<p>Now you can return to <a href=\"http://fiascomobile.com/\">FiascoMobile</a> and log in with your email address. Once you've logged in, bookmark the resulting page.</p> <p>Enjoy FiascoMobile!</p>\n</div>";
                }
        }
}


sub ValidateFail() {
	print "<p>You're probably not supposed to be using this system.</p>
		<p><form action=\"fmadmin.pl\" method=\"post\">
		<label for=\"passphrase\">Enter Administrator passphrase:</label>
		<input name=\"passphrase\" type=\"password\" value=\"\"><input type=\"submit\"></form></p>\n\n</div>";
}

sub validateDomain($) {
	if ($ENV{'HTTP_REFERER'} eq 'http://fiascomobile.ogreteeth.com/admin/fmadmin.pl') { 
		return true;
	}
	elsif ($ENV{'HTTP_REFERER'} eq 'http://brooklynindiegames.com/fm/admin/fmadmin.pl') { 
		return true;
	}
	elsif ($ENV{'HTTP_REFERER'} eq 'http://fiascomobile.com/admin/fmadmin.pl') { 
		return true;
	}
	elsif ($ENV{'HTTP_REFERER'} eq 'http://brooklynindiegames.com/fm/coupon.rb') {
		return true;
	}
	elsif ($ENV{'HTTP_REFERER'} eq 'http://fiascomobile.ogreteeth.com/coupon.rb') {
		return true;
	}
	elsif ($ENV{'HTTP_REFERER'} eq 'http://fiascomobile.com/coupon.rb') { 
		return true;
	}
	else {
		return false;
	}
}

sub debugMode() {
	print "<pre>\n";
	while (($key, $value) = each(%ENV)) {
		print "$key => $value\n";
	}
	print "</pre>\n";
}

print <<EO2;
<h1 class="footer">...on the internet</h1>
</div>
</body>
</html>
EO2
