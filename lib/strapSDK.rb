require 'net/http'
require 'net/https'
require "uri"
require "json"

class StrapSDK
  
  @@token = ""

  $strapAPI = "api2.straphq.com"
  @@path = "/discover"

  @@apis = {}

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
      @@apis[k] = StrapSDKResource.new( @@token, k, v )
    end
  end

  def api(name, params=[])
    if name && @@apis[name]
      return @@apis[name].use(params)
    else
      puts "Invalid Resource"
    end
  end
end

class StrapSDKResource 

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

  def use(params=[])

    # Implement replace of uri params

    # make the call
    http = Net::HTTP.new(@uri, 443)
    http.use_ssl = true
    response = http.get2(@path, {"X-Auth-Token" => @token})

    content = JSON.parse(response.body)
  end
  
end
