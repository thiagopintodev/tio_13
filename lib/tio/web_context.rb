module Tio
  class WebContext
    # extend WebContext::Extension
    # include WebContext::Inclusion
    
    def initialize(app)
      @app = app
    end

    # shortcuts

    delegate :request, to: :web_server

    def web_server
      @app.web_server
    end

    def web_server_class
      @app.web_server_class
    end
  end
end