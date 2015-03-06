#!/usr/local/bin/ruby 

# Example application to demonstrate some basic Ruby features 
# This code loads a given file into an associated application 

class Launcher 

	def initialize( ) 

		require "~/mysrc/strap-sdk-rails/lib/strapSDK.rb"

		strap = StrapSDK.new("QNIODsZ4pPRbeLlEsXElu3W7C0zjS2W3")

		puts strap.api("today")

		puts strap.api("report")

		puts strap.api("activity")

		puts strap.api("users")

	end

end 

launcher = Launcher.new