#!/usr/bin/env ruby

require 'digest/md5'

"Kickstarter Backer Report - No reward - Aug 25 08pm.csv"
"Kickstarter Backer Report - $1.00 USD reward - Aug 25 08pm.csv"

tier_level =


"Kickstarter Backer Report - $10.00 USD reward - Aug 25 08pm.csv"
"Kickstarter Backer Report - $25.00 USD reward 1 - Aug 25 08pm.csv"
"Kickstarter Backer Report - $25.00 USD reward 2 - Aug 25 08pm.csv"
"Kickstarter Backer Report - $50.00 USD reward - Aug 25 08pm.csv"
"Kickstarter Backer Report - $75.00 USD reward - Aug 25 08pm.csv"
"Kickstarter Backer Report - $100.00 USD reward - Aug 25 08pm.csv"
"Kickstarter Backer Report - $250.00 USD reward - Aug 25 08pm.csv"
"Kickstarter Backer Report - $500.00 USD reward - Aug 25 08pm.csv"
"Kickstarter Backer Report - $600.00 USD reward - Aug 25 08pm.csv"
"Kickstarter Backer Report - $1,200.00 USD reward - Aug 25 08pm.csv"
"Kickstarter Backer Report - $2,500.00 USD reward - Aug 25 08pm.csv"
 
puts tier_level

listings = File.open(tier_level, "r")

emails = []
validate = []

listings.each { |line|
	unless line.split(",")[2] == "Email"
		emails.to_a << line.split(",")[2]
	end
	}
listings.close
	
	
# puts emails

emails.each { |user|
	user.gsub!("@", "%40")
	validate.to_a << user + ":" + Digest::MD5.hexdigest(user)
	}

# puts validate

doc = File.open("rewards.txt", "a")
validate.each { |item| doc << item + "\n" }
doc.close
