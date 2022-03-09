module Tio
  module WebServerRackInclusion
    # def self.included(mod)
    #   puts "#{self} included in #{mod}"
    # end

    def run(port: 3000)
      # app = Rack::Builder.new do |builder|
      #   builder.use FilterLocalHost
      #   builder.run RackApp.new
      # end
      # handler.run app
      Rack::Handler::Thin.run self
    end

    def call(env)
      puts env
      binding.irb

      # NOTE: reloading is not working. must try harder >:)
      if @first_load.nil?
        @first_load = true
      else
        r!
      end

      status = 200
      headers = { "Content-Type" => "text/html" }
      body = "Hello World"

      http_method = env['REQUEST_METHOD'].to_sym
      path = env['REQUEST_URI']

      r = web.request(http_method, path)
      body = r.run

      puts
      puts "-" * 100
      puts "REQUEST: #{http_method} #{path}"
      puts "RESPONSE: #{body.size} bytes body"

      Rack::Response.new status, headers, [body]
    rescue => e
      puts "\n\n\n"
      puts "-" * 100
      puts e.class
      puts e.message
      puts e.backtrace
      puts "\n\n\n"
      [ 500, headers, ["(#{e.class}) | #{e.message} <a href='/users'>go back</a>"] ]
    end
  end
end

# TODO: I'm still deciding if run and call should be in the same context as the WebServer instance

# module Tio
#   class RackAdapter
#     def call(env)
#       status = 200
#       headers = { "Content-Type" => "text/plain" }
#       body = "Hello World"
#       [ status, header, [body] ]
#     end
#   end
# end

# Rack::Handler::Thin.run Tio::RackAdapter.new
