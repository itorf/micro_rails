require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase

    def render(template_name)
      file = File.read(
        "views/#{self.class.name.underscore}/#{template_name}.html.erb"
      )
      
      template = ERB.new(file).result(binding)
      render_content(template, 'text/html')
    end
  end
end
