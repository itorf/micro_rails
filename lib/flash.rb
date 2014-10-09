require 'json'
require 'webrick'

module Bonus
  
  class Flash
    
    def initialize(req)
      found = false
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app_flash'
          @flash = JSON.parse(cookie.value)
          found = true
          break
        end
      end
      
      @flash = {} unless found
    end
    
    def [](key)
      @flash[key]
    end
    
    def []=(key, value)
      @flash[key] = value
    end
    
    def store_flash(res)
      value = @flash.to_json
      res.cookies << WEBrick::Cookie.new('_rails_lite_app_flash', value)
    end
  end
  
  
  class ControllerBase < Phase4::ControllerBase
    def redirect_to(url)
      super
      flash.store_flash(res)
    end

    def render_content(content, type)
      super
      flash.store_flash(res)
    end

    def flash
      @flash ||= Flash.new(req)
    end
  end
end
