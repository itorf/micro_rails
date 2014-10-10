require 'uri'

module Phase5
  class Params

    def initialize(req, route_params = {})
      @params = {}
      unless req.query_string.nil?
        @params.merge!(parse_www_encoded_form(req.query_string))
      end
      
      unless req.body.nil?
        @params.merge!(parse_www_encoded_form(req.body))
      end
      
      unless route_params.empty?
        @params.merge!(route_params)
      end
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    
    def parse_www_encoded_form(www_encoded_form)
      decoded_form = URI::decode_www_form(www_encoded_form)
      parameters = {}
      
      decoded_form.each do |key, value|
        params = parameters
        
        key_array = parse_key(key)
        key_array.each do |level|
          if level == key_array.last
            params[level] = value
          else
            params[level] = {}
            params = params[level]
          end
        end
      end
      
      parameters
    end

    def parse_key(key)
      key.gsub(/\]\[|\[|\]/, " ").split(" ")
    end
  end
end
