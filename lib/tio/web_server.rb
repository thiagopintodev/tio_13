module Tio
  class WebServer
    extend WebServerRequestExtension
    include WebServerRequestInclusion
    
    # extend WebServerWebrickExtension
    include WebServerWebrickInclusion
    
    # extend WebServerSessionExtension
    # include WebServerSessionInclusion

    # NOTE: Move this to WebServerNginxExtension
    def self.domain(domain=nil)
      if domain
        @domain = domain
      else
        @domain
      end
    end

    def initialize(app)
      @app = app
    end

    attr_reader :app

    delegate :web, to: :app
  end
end
