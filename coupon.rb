#!/usr/bin/ruby
require "cgi"

cgi = CGI.new
entry = cgi.params["couponcode"].to_s

puts( "Content-type: text/html" );
puts( "" );
puts %q[<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1" />
	<link rel="stylesheet" href="fm.css" type="text/css" media="screen, mobile" title="main">
	<script type="text/javascript" src="jquery-1.4.3.min.js"></script>
	<script>
	function mailvalidate(e) {
		var valid = e.value.toLowerCase()
		e.value = valid;
		}
	</script>
	<link href="http://fonts.googleapis.com/css?family=Syncopate:400,700%7CMetrophobic" rel="stylesheet" type="text/css">
	<title>FiascoMobile Coupon Redemption</title>
</head>
<body>
<nav><img src="img/header.png" alt="Fiasco Mobile" /></nav>

<div id="IOSContainer">
	<h1>Redeem Coupon Code</h1>
	<div class="playset">
]

def valid_coupon_body
	# Except for the stray 'x', this is the call to the perl script that will enter a validated email address.
	puts %q[
	<p>Coupon validated and marked as used. Enter your email address here. This will serve as your login to the application.</p>
	<p><form action="admin/fmadmin.pl" method="post">
	<label for="AAA111">Email:</label>
	<input name="AAA111" type="email" value=""><input type="submit"></form><br /><br /></p>
	</div>
	<h1 class="footer">...on the internet</h1>
</div>
</body>
</html>
]
end

def enter_coupon_body(entry,valid_coupons)
	# Write the main body sample that shows up when you load this page.
	# entry = gets

	if (entry.length > 0)
		puts %q[<p>Coupon not found, or already used.</p>]
	else 
		puts %q[<p>Thanks for purchasing FiascoMobile. We've just put together this coupon redemption system and have our fingers crossed that it works well. Please <a href="mailto:support@brooklynindiegames.com">let us know</a> if you encounter any difficulties.</p>]
	end

	puts %q[
	<p><form action="coupon.rb" method="post">
	<label for="couponcode">Enter Coupon Code:</label>
	<input name="couponcode" type="text" value=""><input type="submit"><br /><br />
	</form></p>]

	# print "<p>Remaining Coupons: "
	# puts valid_coupons.inspect
	
	puts %q[</p>
	</div>
	<h1 class="footer">...on the internet</h1>
	</div>
</body>
</html>
]
end


valid_coupons = []

coupons = File.open("/home/epistech/data/fiascomobile/fmcoupons.txt", "r")
# coupons = File.open("fmcoupon.txt", "r")
coupons.each { |line| valid_coupons.to_a << line.to_s.chomp! }
coupons.close

# print "Valid Coupons: " 
# print valid_coupons.inspect
# puts "<br />"

# print "Entered Code: "
# print entry.inspect 
# puts "<br />" 


if (valid_coupons.include?(entry))
	valid_coupon_body
	
	#array method _delete_ deletes a matched _obj_ which I can then rewrite the file with.
	valid_coupons.delete(entry)
		
	# coupons = File.open("fmcoupon.txt", "w+")
	coupons = File.open("/home/epistech/data/fiascomobile/fmcoupons.txt", "w+")
	valid_coupons.each { |item| coupons << item + "\n" }
	coupons.close
else 
	enter_coupon_body(entry, valid_coupons)
end
