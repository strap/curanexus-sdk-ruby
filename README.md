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
# strap.activity.get( {"date" => "YYYY-MM-DD", "guid" => "demo-strap"} )
# URL resources can be passed as Strings or in the Array
strap.activity.get( "demo-strap" )

# Optional Param can be passed in as an array
# strap.activity.get( {"date" => "YYYY-MM-DD", "guid" => "demo-strap"} )
# URL resources can be passed as Strings or in the Array
strap.activity.get( "demo-strap" )

# Fetch a user's activity
# URL resource: "guid"
# Optional: "date", "count"
puts strap.activity.get({"guid" => "brian-test"})
# Same as 
puts strap.activity.get("brian-test")

# Fetch a user's behavior
# URL resource: "guid"
# Optional: none
puts strap.behavior.get({"guid" => "brian-test"})
# Same as 
puts strap.behavior.get("brian-test")

# Fetch a list of micro-segmentation or specific segmentation job
# URL resource: "id"
# Optional: "id", "status"
puts strap.job.get()

# Create a micro-segmentation job
# URL resource: none
# Required: "name"
# Optional: "description", "guids" "startDate", "endDate", "notificationUrl" >> Guid is array of strings
puts strap.job.post()

# Update a micro-segmentation job
# URL resource: "id"
# Required: "id"
# Optional: "name", "description"
puts strap.job.put()

# Delete a micro-segmentation job
# URL resource: "id"
# Required: "id"
# Optional: none
puts strap.job.delete()

# Fetch a the data for a specific segmentation job
# URL resource: "id"
# Optional: "id"
puts strap.job_data.get()

# Fetch all user data for the month
# URL resource: none
# Optional: "guid", "page", "per_page"
puts strap.month.get()

# Fetch a report's data
# URL resource: "id"
# Optional: none
puts strap.report.get("report - id value")

# Fetch a report's food data
# URL resource: "id"
# Optional: none
puts strap.report_food.get("report - id value")

# Fetch a report's raw data
# URL resource: "id"
# Optional: none
puts strap.report_raw.get("report - id value")

# Fetch a report's workout data
# URL resource: "id"
# Optional: none
puts strap.report_workout.get("report - id value")

# Fetch all user data for today
# URL resource: none
# Optional: "guid", "page", "per_page"
puts strap.today.get()

# Fetch a user trend information
# URL resource: "guid"
# Optional: none
puts strap.trend.get({"guid" => "brian-test"})
# Same as 
puts strap.trend.get("brian-test")

# Fetch a list of triggers or specific trigger
# URL resource: "id"
# Optional: "id", "key", "type", "actionType"
puts strap.trigger.get()

# Create a trigger
# URL resource: none
# Required: "active", "name", "type", "range", "conditions"
# Optional: "actionType", "actionUrl"
puts strap.trigger.post()

# Update a micro-segmentation trigger
# URL resource: "id"
# Required: "id"
# Optional: "active", "name", "type", "range", "conditions", "actionType", "actionUrl"
puts strap.trigger.put()

# Delete a micro-segmentation trigger
# URL resource: "id"
# Required: "id"
# Optional: none
puts strap.trigger.delete()

# Fetch trigger data
# URL resource: "id"
# Optional: "count"
puts strap.trigger_data.get()

# Fetch a simple user object
# URL resource: "guid"
# Optional: none
puts strap.user.get({"guid" => "brian-test"})
# Same as 
puts strap.user.get("brian-test")

# Fetch a user list for the Project
# URL resource: none
# Optional: "platform", "count"
puts strap.users.get()

# Fetch all user data for the week
# URL resource: none
# Optional: "guid", "page", "per_page"
puts strap.week.get()


```
