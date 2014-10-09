require 'json'
require 'webrick'

module CSRFToken
  
  class CSRF
    
    def initialize(req)
      found = false
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app_csrf'
          @csrf = JSON.parse(cookie.value)
          found = true
          break
        end
      end
      
      @csrf = {} unless found
    end
    
    def [](authenticity_token)
      @csrf[authenticity_token]
    end
    
    def []=(authenticity_token, token)
      @csrf[authenticity_token] = token
    end
    
    def store_token(res)
      value = @csrf.to_json
      res.cookies << WEBrick::Cookie.new('_rails_lite_app_csrf', value)
    end
  end
end