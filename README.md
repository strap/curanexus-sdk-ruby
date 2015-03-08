# Strap SDK Ruby

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
# Require the StrapSDK
require "lib/strapSDK.rb"

# Setup Strap SDK
strap = StrapSDK.new("Read Token Project Value")

# Get the data for today
puts strap.api("today", {"guid"=>"sdfasdfasdf", "page"=>1})  # optional second array

# Get a specfic report by ID
puts strap.api("report",{"id"=>"asdfasdfasdfasdf"}) # id required

# Get all activity for a date
puts strap.api("activity", {"guid"=>"sdfasdfasdf", "day"=>"YYYY-MM-DD", "count" => 500}) #guid is required

# Get a user list
puts strap.api("users", {"platform"=>"fitbit", "count"=>100 })  # optional second array

```
