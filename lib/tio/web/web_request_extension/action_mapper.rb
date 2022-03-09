module Tio
  module WebRequestExtension
    class ActionMapper
      def initialize
        @befores = []
        @befores.push([])

        @all = {}
      end

      def open_group
        @befores.push(@befores.last.dup)
      end

      def close_group
        @befores.pop
      end

      def add_before(&action)
        @befores.last.push(action)
      end

      def add(name, format, action)
        list = @all[name] ||= []

        @befores.last.each do |act|
          list << _action(format, act)
        end

        list << _action(format, action)
      end

      def filter(name, format)
        VALID_FORMATS.argument_error(format)

        list = @all[name] || []
        list.select { |h| h[:format] == nil || h[:format] == format }
            .map    { |h| h[:action] }
      end

      private
      
      def _action(format, action)
        {format: format, action: action}
      end
    end
  end
end