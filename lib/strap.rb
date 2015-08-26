require 'net/http'
require 'net/https'
require "json"
require "cgi"

class Strap
  
  @@token = ""

  $strapAPI = "api2.straphq.com"
  @@path = "/discover"

  @@apis = {}

  @@resources = {}

  # Method Placeholders
  @@activity = {}
  @@behavior = {}
  @@job = {}
  @@job_data = {}
  @@month = {}
  @@report = {}
  @@report_food = {}
  @@report_raw = {}
  @@report_workout = {}
  @@today = {}
  @@trend = {}
  @@trigger = {}
  @@trigger_data = {}
  @@user = {}
  @@users = {}
  @@week = {}

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
      # puts k

      @@resources[ k ] = v

      case k
      when "activity"
        @@activity = StrapResource.new( @@token, v )
      when "behavior"
        @@behavior = StrapResource.new( @@token, v )
      when "job"
        @@job = StrapResource.new( @@token, v )
      when "job_data"
        @@job_data = StrapResource.new( @@token, v )
      when "month"
        @@month = StrapResource.new( @@token, v )
      when "report"
        @@report = StrapResource.new( @@token, v )
      when "report_food"
        @@report_food = StrapResource.new( @@token, v )
      when "report_raw"
        @@report_raw = StrapResource.new( @@token, v )
      when "report_workout"
        @@report_workout = StrapResource.new( @@token, v )
      when "segmentation"
        @@segmentation = StrapResource.new( @@token, v )
      when "today"
        @@today = StrapResource.new( @@token, v )
      when "trend"
        @@trend = StrapResource.new( @@token, v )
      when "trigger"
        @@trigger = StrapResource.new( @@token, v )
      when "trigger_data"
        @@trigger_data = StrapResource.new( @@token, v )
      when "user"
        @@user = StrapResource.new( @@token, v )
      when "users"
        @@users = StrapResource.new( @@token, v )
      when "week"
        @@week = StrapResource.new( @@token, v )
      else
        #do nothing
      end
    end
  end

  def endpoints
    @@resources
  end

  # Hook up the methods on the main class
  def activity 
    return @@activity 
  end
  def behavior 
    return @@behavior 
  end
  def job 
    return @@job 
  end
  def job_data 
    return @@job_data 
  end
  def month 
    return @@month 
  end
  def report 
    return @@report 
  end
  def report_food
    return @@report_food
  end
  def report_raw 
    return @@report_raw 
  end
  def report_workout
    return @@report_workout
  end
  def today 
    return @@today 
  end
  def trend 
    return @@trend 
  end
  def trigger 
    return @@trigger 
  end
  def trigger_data
    return @@trigger 
  end
  def user 
    return @@user 
  end
  def users 
    return @@users 
  end
  def week 
    return @@week 
  end

end

class StrapResource 

  attr_accessor :token
  attr_accessor :details
  attr_accessor :uri
  attr_accessor :hasNext
  attr_accessor :params
  attr_accessor :pageData
  attr_accessor :pageDefault
  attr_accessor :suppress

  def initialize(token,details)

    @token = token
    @details = details

    @uri = $strapAPI
    @pageData = {};
    @pageDefault = {
                    "page" => 1,
                    "pages" => 1,
                    "next" => 2,
                    "per_page" => 30
                  }

    val = self.pullMethod("GET")
    # Skip next and getAll on non page'd resources
    if !val || val.count('page') == 0
      @suppress = true
    end
  end

  def next
    # This method should not being doing this...
    if @suppress 
      return false;
    end

    if @hasNext 

      page = { 
                "page"      => @pageData["next"],
                "per_page"  => @pageData["per_page"]
              }

      return self.get( @params, page);
    else 
      return false;
    end
  end

  def all(params={})

    # This method should not being doing this...
    if @suppress 
      return false;
    end
    
    data = self.get(params)

    while @hasNext
      data = data.merge( self.next() )
    end

    data
  end

  def get(params={},page={})

    details = self.pullMethod("GET")

    # split part the uri to grab the path
    parts = details["uri"].split($strapAPI)

    my_path = parts[1]
    method = details["method"]

    if method != "GET"
      return {"error"=>"method not allowed"}
    end

    # Replace of uri params
    match = my_path.scan(/{([^{}]+)}/i)

    # Store this for next()
    @params = params

    # Check the type of params
    if  params && params.is_a?(String) # Check for only string
        paramString = params
        params = Hash.new()
    end

    # Setup the Paging info in the request
    temp_page = {
                "page" => ( params["page"] ) ? params["page"] : @pageDefault["page"],
                "per_page" => ( params["per_page"] ) ? params["per_page"] : @pageDefault["per_page"]
    }

    # Merge them together
    @pageData = temp_page.merge(page)

    # Merge the page data into request
    # Give preference to params
    params = @pageData.merge(params)

    # Matches returns 
    # [ [ "guid" ] ]

    # Handle all the URL strings
    if match.length > 0

      # Fix the Ruby return
      match = match[0][0]

      # Get valure to replace with or default to clear the param fir the uri
      if paramString 
        val = paramString
      else
        val = ( params.has_key?(match) ) ? params[match] : ""
      end

      #puts val

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

    # make the call
    http = Net::HTTP.new(@uri, 443)
    http.use_ssl = true
    response = http.get2(my_path, {"X-Auth-Token" => @token})

    # Handle the Page Headers
    if response["X-Pages"] == response["X-Page"]
        @hasNext = false;
        # Reset the Default Page information
        @pageData = @pageDefault;
    else
        # Set the main pageData
        @pageData = @pageData.merge({   "page"   => response["X-Page"],
                                        "pages"  => response["X-Pages"],
                                        "next"   => response["X-Next-Page"]
                                    })
        @hasNext = true;
    end

    content = JSON.parse(response.body || "[]")
  end

  def post(params={})

    details = self.pullMethod("POST")

    # split part the uri to grab the path
    parts = details["uri"].split($strapAPI)

    my_path = parts[1]
    method = details["method"]

    if method != "POST"
      return {"error"=>"method not allowed"}
    end

    # make the call
    http = Net::HTTP.new(@uri, 443)
    http.use_ssl = true
    response = http.post(my_path, params.to_json, {"X-Auth-Token" => @token, "Content-Type" => "application/json"})

    content = JSON.parse(response.body || "[]")
  end

  def put(params={})

    details = self.pullMethod("PUT")

    # split part the uri to grab the path
    parts = details["uri"].split($strapAPI)

    my_path = parts[1]
    method = details["method"]

    if method != "PUT"
      return {"error"=>"method not allowed"}
    end

    # Replace of uri params
    match = my_path.scan(/{([^{}]+)}/i)

    # Store this for next()
    @params = params

    # Check the type of params
    if  params && params.is_a?(String) # Check for only string
        paramString = params
        params = Hash.new()
    end

    # Matches returns 
    # [ [ "guid" ] ]

    # Handle all the URL strings
    if match.length > 0

      # Fix the Ruby return
      match = match[0][0]

      # Get valure to replace with or default to clear the param fir the uri
      if paramString 
        val = paramString
      else
        val = ( params.has_key?(match) ) ? params[match] : ""
      end

      #puts val

      # Do the actual replacement
      my_path = my_path.gsub( "{" + match + "}", val)

      # Remove the value from the params
      if params.has_key?(match)
          params.delete(match);
      end

    end

    # make the call
    http = Net::HTTP.new(@uri, 443)
    http.use_ssl = true
    response = http.request_put(my_path, params.to_json, {"X-Auth-Token" => @token, "Content-Type" => "application/json"})

    content = JSON.parse(response.body || "[]")
  end

  def delete(params={})

    details = self.pullMethod("DELETE")

    # split part the uri to grab the path
    parts = details["uri"].split($strapAPI)

    my_path = parts[1]
    method = details["method"]

    if method != "DELETE"
      return {"error"=>"method not allowed"}
    end

    # Replace of uri params
    match = my_path.scan(/{([^{}]+)}/i)

    # Store this for next()
    @params = params

    # Check the type of params
    if  params && params.is_a?(String) # Check for only string
        paramString = params
        params = Hash.new()
    end

    # Matches returns 
    # [ [ "guid" ] ]

    # Handle all the URL strings
    if match.length > 0

      # Fix the Ruby return
      match = match[0][0]

      # Get valure to replace with or default to clear the param fir the uri
      if paramString 
        val = paramString
      else
        val = ( params.has_key?(match) ) ? params[match] : ""
      end

      #puts val

      # Do the actual replacement
      my_path = my_path.gsub( "{" + match + "}", val)

      # Remove the value from the params
      if params.has_key?(match)
          params.delete(match);
      end

    end

    # make the call
    http = Net::HTTP.new(@uri, 443)
    http.use_ssl = true
    response = http.delete(my_path, {"X-Auth-Token" => @token})

    content = JSON.parse(response.body || "[]")
  end

  def pullMethod(type)
    @details.each do |k, v|
      if k["method"] == type
        return k
      end
    end
    return false
  end
  
end
