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

# Setup Strap SDK
strap = Strap.new("Read Token Project Value")

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

```
