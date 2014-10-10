require 'json'
require 'webrick'

module Phase4
  class Session

    def initialize(req)
      found = false
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @cookie_info = JSON.parse(cookie.value)
          found = true
          break
        end
      end
      
      @cookie_info = {} unless found
    end

    def [](key)
      @cookie_info[key]
    end

    def []=(key, val)
      @cookie_info[key] = val
    end

    def store_session(res)
      value = @cookie_info.to_json
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', value)
    end
  end
end

