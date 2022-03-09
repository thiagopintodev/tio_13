module Tio
  module WebServerRequestInclusion
    # def self.included(mod)
    #   puts "#{self} included in #{mod}"
    # end

    def request(*args)
      return self.class.requests.router.nav if args.empty?

      [:GET, :POST].argument_error args[0]
      String.argument_error args[1]

      return self.class.requests.router.find_by_path(args[0], args[1])
    end
  end
end
