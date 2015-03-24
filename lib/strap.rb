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
  @@month = {}
  @@report = {}
  @@today = {}
  @@trigger = {}
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
      when "month"
        @@month = StrapResource.new( @@token, v )
      when "report"
        @@report = StrapResource.new( @@token, v )
      when "month"
        @@month = StrapResource.new( @@token, v )
      when "today"
        @@today = StrapResource.new( @@token, v )
        when "trigger"
        @@trigger = StrapResource.new( @@token, v )
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
  def month 
    return @@month 
  end
  def report 
    return @@report 
  end
  def today 
    return @@today 
  end
  def trigger 
    return @@trigger 
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
  attr_accessor :uri
  attr_accessor :method
  attr_accessor :req
  attr_accessor :opt
  attr_accessor :hasNext
  attr_accessor :params
  attr_accessor :pageData
  attr_accessor :pageDefault
  attr_accessor :suppress

  def initialize(token,details)
    # split part the uri to grab the path
    parts = details["uri"].split($strapAPI)

    @token = token
    @uri = $strapAPI
    @path = parts[1]
    @method = details["method"]
    @req = details["required"]
    @opt = details["optional"] || []
    @pageData = {};
    @pageDefault = {
                    "page" => 1,
                    "pages" => 1,
                    "next" => 2,
                    "per_page" => 30
                  }

    # Skip next and getAll on non page'd resources
    if !@opt || @opt.count('page') == 0
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

    # Replace of uri params
    match = @path.scan(/{([^{}]+)}/i)

    # Setup path to mess with
    my_path = @path

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

      puts val

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
  
end
