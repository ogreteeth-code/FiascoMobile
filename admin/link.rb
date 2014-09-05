# DON"T SHEBANG THIS FOR SAFETY PURPOSES #!/usr/bin/ruby

validationfile = ""

keys = File.open(validationfile, "r")

keys.each { |line|
	code = line.split(":")[1].chomp
	#puts code
	link = "../lns/" + code + ".php"
		
  unless  File.exists?(link) 
    system("ln -s ../fiascomobile.php ../lns/" + code + ".php")
  else 
    puts code + ".php already exists. Moving on..."
  end

	}
keys.close
