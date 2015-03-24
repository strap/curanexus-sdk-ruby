# Ruby > Strap Server-Side SDK

Strap SDK Ruby provides an easy to use, chainable API for interacting with our
API services.  Its purpose is to abstract away resource information from
our primary API, i.e. not having to manually track API information for
your custom API endpoint.

Strap SDK Ruby keys off of a global API discovery object using the read token for the API. 
The Strap SDK Ruby extracts the need for developers to know, manage, and integrate the API endpoints.

The a Project API discovery can be found here:

HEADERS: "X-Auth-Token": 
GET [https://api2.straphq.com/discover]([https://api2.straphq.com/discover)

Once the above has been fetched, `strapSDK` will fetch the API discover
endpoint for the project and build its API.

### Installation

```
git clone git@github.com:strap/strap-sdk-ruby.git
```

### Usage

Below is a basic use case.

```ruby
# Require the Strap
require "lib/strap.rb"

strap = Strap.new("{ Project Read Token }")

# List available endpoints
# puts strap.endpoints();
# No Params

# Each endpoint that supports the "page" value also exposes two additional methods and two detail values
# Get the next set of records
set = strap.month.next(); 
# Get All set of records until the max page count is reached
strap.month.all( params ); 
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


```
