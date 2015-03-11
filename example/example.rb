#!/usr/local/bin/ruby 

# Example application to demonstrate some basic Ruby features 
# This code loads a given file into an associated application 

class Launcher 

	def initialize( ) 

		require "~/mysrc/strap-sdk-rails/lib/strap.rb"

		strap = Strap.new("{ Project Read Token }")

		# List available endpoints
	    puts strap.endpoints();
	    # No Params

		# Optional Param can be passed in as an array
	    # strap.getActivity( ["day" => "YYYY-MM-DD", "guid" => "demo-strap"] )
	    # URL resources can be passed as Strings or in the Array
	    # strap.getActivity( "demo-strap" )

		# Fetch a user's activity
		# URL resource: "guid"
		# Optional: "day", "count"
		puts strap.getActivity({"guid" => "brian-test"})
		# Same as puts strap.getActivity("brian-test")

		# Fetch a report's data
		# URL resource: "id"
		# Optional: none
		puts strap.getReport()

		# Fetch all user data for today
		# URL resource: none
		# Optional: "guid", "page"
		puts strap.getToday()

		# Fetch trigger data
		# URL resource: "id"
		# Optional: "count"
		puts strap.getTrigger()

		# Fetch a user list for the Project
		# URL resource: none
		# Optional: "platform", "count"
		puts strap.getUsers()

	end

end 

launcher = Launcher.new