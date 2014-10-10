module Phase2
  class ControllerBase
    attr_reader :req, :res

    def initialize(req, res)
      @req = req
      @res = res
      @already_built_response = false
    end

    def already_built_response?
      @already_built_response
    end

    def redirect_to(url)
      raise 'already built response' if @already_built_response
      res.status = 302 
      res.header["location"] = url
      @already_built_response = true
    end

    def render_content(content, type)
      raise 'already built response' if @already_built_response
      res.body = content
      res.content_type = type
      @already_built_response = true
    end
  end
end