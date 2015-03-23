#!/usr/local/bin/ruby 

# Example application to demonstrate some basic Ruby features 
# This code loads a given file into an associated application 

class Launcher 

	def initialize( ) 

		require "./lib/strap.rb"

		#strap = Strap.new("{ Project Read Token }")
		strap = Strap.new("QNIODsZ4pPRbeLlEsXElu3W7C0zjS2W3")

		# List available endpoints
	    # puts strap.endpoints();
	    # No Params

	    # Each endpoint that supports the "page" value also exposes two additional methods and two detail values
	    # Get the next set of records
	    set = strap.month.next(); 
	    # Get All set of records until the max page count is reached
	    strap.month.getAll( params ); 
	    # Get the page information for the request
	    strap.month.pageData # Contains the "page", "next", "pages", "per_page" information for the request
	    # Check to see if there is a next page
	    strap.month.hasNext # Contains BOOL true || false if there is more data that can be pulled

		# Optional Param can be passed in as an array
	    # strap.activity.get( {"day" => "YYYY-MM-DD", "guid" => "demo-strap"} )
	    # URL resources can be passed as Strings or in the Array
	    strap.activity.get( "demo-strap" )

		# Fetch a user's activity
		# URL resource: "guid"
		# Optional: "day", "count"
		puts strap.activity.get({"guid" => "brian-test"})
		# Same as 
		puts strap.activity.get("brian-test")

		# Fetch all user data for the month
		# URL resource: none
		# Optional: "guid", "page", "per_page"
		puts strap.month.get()

		# Fetch a report's data
		# URL resource: "id"
		# Optional: none
		puts strap.report.get("report - id value")

		# Fetch all user data for today
		# URL resource: none
		# Optional: "guid", "page", "per_page"
		puts strap.today.get()

		# Fetch trigger data
		# URL resource: "id"
		# Optional: "count"
		puts strap.trigger.get()

		# Fetch a user list for the Project
		# URL resource: none
		# Optional: "platform", "count"
		puts strap.users.get()

		# Fetch all user data for the week
		# URL resource: none
		# Optional: "guid", "page", "per_page"
		puts strap.week.get()

	end

end 

launcher = Launcher.new