require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
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
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
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

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.gsub(/\]\[|\[|\]/, " ").split(" ")
    end
  end
end
