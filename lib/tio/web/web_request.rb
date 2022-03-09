module Tio
  class WebRequest
    extend WebRequestExtension

    # NOTE: this will not be global in the future
    # NOTE: This is a shortcut, to help write path helpers
    # <%= web.request.users.edit(@user[:id]).path %>
    def web
      $app.web
    end

    def initialize(http_method, path, action_name, format, params)
      @action_name, @format, @http_method = action_name, format, http_method

      @path = path.empty? ? '/' : "/#{path}.#{format}"

      # puts "params: #{params}"

      params(params)
    end

    def params(params)
      params.each do |k, v|
        k = k.to_s if k.is_a? Symbol
        k = "@#{k}" if k[0] != '@'
        instance_variable_set(k, v)
      end

      self
    end

    attr_reader :path

    def url
      "#{WebServer.domain}#{@path}"
    end

    def authenticate
      
    end

    # @action_name, @format, @http_method, @path, @params
    def run(_headers={})

      @layout, @wrapper, @template = self.class._get_views(@action_name, @format)

      self.class._get_actions(@action_name, @format).each do |action|
        instance_eval(&action)
        # TODO: what if anything stops the execution?
        # TODO: what if it's authe?
        # TODO: what if it's autho?
        # TODO: what if it's a redirect?
      end

      messy = _run
      HtmlBeautifier.beautify(messy, indent: "    ")
    end

    def content(name, format = @format)
      content = self.class._get_content(name, format)

      raise "only ERB" if content[:renderer] != :erb

      _erb content[:view]
    end

    def _run
      _run_render @layout[:renderer], @layout[:view] do
        _run_render @wrapper[:renderer], @wrapper[:view] do
          _run_render @template[:renderer], @template[:view]
        end
      end
    end

    def _run_render(renderer, view, &block)
      raise "only ERB" if renderer != :erb

      _erb view, &block
    end

    def _erb(view)
      ERB.new(view).result(binding)
    end

    def _haml(view)
      # Haml.new(view).result(binding)
    end

    # Layouts

    # 'Making layouts optional'
    # There must be a default layout at the top-level

    # layout :html, :erb, <<-CODE
    layout <<-CODE
      <!DOCTYPE html>
      <html>
          <head>
              <title>My App</title>
              <%#= stylesheet_link_tag    "application", media: "all" %>
              <%#= javascript_include_tag "application" %>
              <%#= csrf_meta_tags %>
          </head>
          <body>

            <%= yield %>

          </body>
      </html>
    CODE

    # Wrappers

    # 'Making wrappers optional'
    # There must be a default wrapper at the top-level

    # wrapper :html, :erb, <<-CODE
    wrapper <<-CODE
      <!-- yield -->
      <%= yield %>
      <!-- /yield -->
    CODE

    # 'Making templates mandatory'
    # There must be a default template at the top-level

    template :template, <<-CODE
      View not found for action <%= @action_name %> on <%= self.class.name %>
    CODE

  end
end