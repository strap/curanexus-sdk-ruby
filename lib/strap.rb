require 'net/http'
require 'net/https'
require "json"
require "cgi"

class Strap
  
  @@token = ""

  $strapAPI = "api2.straphq.com"
  @@path = "/discover"

  @@map = {
    "activity" => "getActivity",
    "report" => "getReport",
    "today" => "getToday",
    "trigger" => "getTrigger",
    "users" => "getUsers"
  }

  @@apis = {}

  @@resources = {}

  def initialize(token=false)
    if !token 
      puts "Read token not provided"
      return
    end
    
    @@token = token

    http = Net::HTTP.new($strapAPI, 443)
    http.use_ssl = true
    response = http.get2(@@path, {"X-Auth-Token" => @@token})

    content = JSON.parse(response.body)

    content.each do |k, v|
      puts k
      @@apis[k] = StrapResource.new( @@token, k, v )

      @@resources[ @@map[k] ] = v
    end
  end

  def endpoints
    @@resources
  end

  def getActivity(params=[])
      @@apis["activity"].use(params)
  end

  def getReport(params=[])
      @@apis["report"].use(params)
  end

  def getToday(params=[])
      @@apis["today"].use(params)
  end

  def getTrigger(params=[])
      @@apis["trigger"].use(params)
  end

  def getUsers(params=[])
      @@apis["users"].use(params)
  end

end

class StrapResource 

  attr_accessor :token
  attr_accessor :name
  attr_accessor :uri
  attr_accessor :method
  attr_accessor :req
  attr_accessor :opt

  def initialize(token,name,details)
    # split part the uri to grab the path
    parts = details["uri"].split($strapAPI)

    @token = token
    @name = name
    @uri = $strapAPI
    @path = parts[1]
    @method = details["method"]
    @req = details["required"]
    @opt = details["optional"]

  end

  def use(params={})

    # Force hash type
    if !params.is_a?(String)
      params = ( params.length > 0 ) ? params : Hash.new()
    end 

    # Replace of uri params
    match = @path.scan(/{([^{}]+)}/i)

    # Setup path to mess with
    my_path = @path

    # Matches returns 
    # [ [ "guid" ] ]

    # Handle all the URL strings
    if match.length > 0

      # Fix the Ruby return
      match = match[0][0]

      # Get valure to replace with or default to clear the param fir the uri
      if params.is_a?(String)
        val = params
        params = Hash.new()  # Make sure to overwrite it with new Hash
      else
        val = ( params.has_key?(match) ) ? params[match] : ""
      end

      # Do the actual replacement
      my_path = my_path.gsub( "{" + match + "}", val)

      # Remove the value from the params
      if params.has_key?(match)
          params.delete(match);
      end

    end

    # See if we have params to query-up
    if params.length > 0
        querystring = params.map{ |k,v| "#{CGI.escape(k)}=#{CGI.escape(v.to_s)}" }.join("&")

        my_path = my_path + '?' + querystring;
    end

    # Final Path
    fin_path = my_path || @path

    # make the call
    http = Net::HTTP.new(@uri, 443)
    http.use_ssl = true
    response = http.get2(fin_path, {"X-Auth-Token" => @token})

    content = JSON.parse(response.body || "[]")
  end
  
end
