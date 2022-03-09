module Tio
  module WebServerRequestExtension
    # def self.extended(mod)
    #   puts "#{self} extended in #{mod}"
    # end

    # def requests(&block)
    #   if block_given?
    #     # writing-mode
    #     @requests = nil
    #     @requests_block = block
    #   else
    #     # reading-mode
    #     return @requests if @requests

    #     # TODO: @requests.is_a? Proc

    #     raise "must set @requests_block" if @requests_block.nil?

    #     @requests = Settings.new
    #     @requests.instance_eval &@requests_block
    #     @requests
    #   end
    # end

    def requests(&block)
      # reading-mode
      return @requests if @requests.is_a? Settings

      # writing-mode
      return @requests = block if block_given?
      
      # reading-mode
      if @requests.is_a? Proc
        x = Settings.new
        x.instance_eval &@requests
        @requests = x
      end

      raise "#{self.class}.requests unset!"
    end
  end
end