#!/Users/timrodriguez/.rvm/rubies/ruby-2.1.0/bin/ruby

relationships_raw = "Home
1. Thing a
2. thing b
3. thing c"

relationships = relationships_raw.split("\n")

relationships.each do |item|
	puts "AAA: $#{item}"
end