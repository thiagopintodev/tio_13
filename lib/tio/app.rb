module Tio
  class App
    def self.set_web_server(web_server_class)
      @@web_server_class = web_server_class
    end

    def web_server_class
      @@web_server_class || raise("App.web_server_class unset!")
    end

    def web_server
      @web_server ||= web_server_class.new(self)
    end

    def web
      @web ||= WebContext.new(self)
    end
  end
end