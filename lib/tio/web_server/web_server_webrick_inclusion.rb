module Tio
  module WebServerWebrickInclusion
    # def self.included(mod)
    #   puts "#{self} included in #{mod}"
    # end

    def run(port: 8000)
      options = {
        Port: port,
        DocumentRoot: web.static_root
      }
      server = WEBrick::HTTPServer.new(options)

      Kernel.trap 'INT' do
        server.shutdown
      end

      server.mount_proc '/' do |req, res|
        # add an empty line in the server logs between requests
        puts
        _run_webrick(req, res)

        # res.status = 200
        # res.header
        # res.body = 'Hello, world!'
      end

      server.start
    end

    def _run_webrick(req, res)
      # # NOTE: reloading is not working. must try harder >:)
      # if @first_load.nil?
      #   @first_load = true
      # else
      #   r!
      # end

      status = 200
      headers = { "Content-Type" => "text/html" }
      body = "Hello World"

      http_method = req.request_method.to_sym
      path = req.path

      r = web.request(http_method, path)
      body = r.run

      res.status = status
      # res.header = headers
      res.body   = body
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
