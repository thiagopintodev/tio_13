require 'colorize'
require 'active_support/all'
require 'erb'
require 'htmlbeautifier'

require 'rack'
require 'thin'

module Tio
  VERSION = '0.0.0'
  
  class View < String
    attr_reader :renderer
    def initialize(renderer, s)
      @renderer = renderer
      super(s)
    end
  end
end





#  ██████  ██████  ██████  ███████ 
# ██      ██    ██ ██   ██ ██      
# ██      ██    ██ ██████  █████   
# ██      ██    ██ ██   ██ ██      
#  ██████  ██████  ██   ██ ███████ 


# TODO: study refinements
# https://docs.ruby-lang.org/en/3.1/doc/syntax/refinements_rdoc.html

# module Tio
#   refine String
#     def to_request_class
#     end
#   end

#   def build(name)
#     klass = name.to_request_class
    
#     klass.new
#   end
# end


5.times { puts }

$counter = 0

module Kernel
  def is_not_a?(klass)
    !is_a?(klass)
  end
end

class Array

  def doesnt_include?(item)
    !include?(item)
  end

  def argument_error(arg)
    self.include?(arg) or raise(StandardError, "Value `#{arg}` should be in #{self}", caller[1..-1])
  end
end

class Class
  public :eval

  def argument_error(arg)
    arg.is_a?(self) or raise(ArgumentError, "Argument `#{arg}` should be a #{self}", caller[1..-1])
  end

  def implements(name, strategy = :default)
    strategy_mod = "#{self.name}::#{name.to_s.camelize}#{strategy.to_s.camelize}"

    class_eval <<-CODE
      def self.#{name}(&block)
        @#{name}_block = block
      end

      def self.#{name}_settings
        return @#{name}_settings if @#{name}_settings

        raise "must set @#{name}_block" if @#{name}_block.nil?

        @#{name}_settings = #{strategy_mod}::Settings.new
        @#{name}_settings.instance_eval &@#{name}_block
        @#{name}_settings
      end

      def #{name}
        @#{name} ||= #{strategy_mod}::Manager.new(self.class.#{name}_settings)
      end
    CODE
  end
end







