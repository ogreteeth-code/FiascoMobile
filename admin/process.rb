#!/usr/bin/env ruby

require 'digest/md5'

tier_level = "kickstarter report.csv"

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
