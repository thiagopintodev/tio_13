module Tio
  module WebRequestExtension
    VALID_FORMATS = [:html]
    VALID_RENDERERS = [:erb]

    def self.extended(mod)
      def mod.inherited(subclass)
        # TODO: clean up ivars and cvars
        puts "[BIG TEST] class #{subclass} < #{self}\n           end".light_yellow
      end
    end

    #  █████   ██████ ████████ ██  ██████  ███    ██     ███    ███ ███████ ████████ ██   ██  ██████  ██████  ███████ 
    # ██   ██ ██         ██    ██ ██    ██ ████   ██     ████  ████ ██         ██    ██   ██ ██    ██ ██   ██ ██      
    # ███████ ██         ██    ██ ██    ██ ██ ██  ██     ██ ████ ██ █████      ██    ███████ ██    ██ ██   ██ ███████ 
    # ██   ██ ██         ██    ██ ██    ██ ██  ██ ██     ██  ██  ██ ██         ██    ██   ██ ██    ██ ██   ██      ██ 
    # ██   ██  ██████    ██    ██  ██████  ██   ████     ██      ██ ███████    ██    ██   ██  ██████  ██████  ███████ 

    # developers

    def before(&block)
      block_given? || raise(ArgumentError, "No block given")

      _action_mapper.add_before(&block)
    end

    def group(&block)
      block_given? || raise(ArgumentError, "No block given")

      _action_mapper.open_group
      instance_eval(&block)
      _action_mapper.close_group
    end

    def action(name, format = nil, &block)
      block_given? || raise(ArgumentError, "No block given")
      
      _action_mapper.add(name, format, block)
    end

    # framework

    def _action_mapper
      @action_mapper ||= ActionMapper.new
    end

    # TOP-DOWN:
    # Tio::WebRequest
    # AppRequest
    # RootRequest
    def _action_mappers
      @action_mappers ||=  ancestors.select { |c| c.respond_to?(:_action_mapper) }
                                    .map(&:_action_mapper)
                                    .reverse
    end

    def _get_actions(name, format)
      # @action_cache["#{name}.#{format}"] ||= 
      _action_mappers.map { |am| am.filter(name, format) }
                     .flatten
                     .reject(&:blank?)
    end

    # ██    ██ ██ ███████ ██     ██     ███    ███ ███████ ████████ ██   ██  ██████  ██████  ███████ 
    # ██    ██ ██ ██      ██     ██     ████  ████ ██         ██    ██   ██ ██    ██ ██   ██ ██      
    # ██    ██ ██ █████   ██  █  ██     ██ ████ ██ █████      ██    ███████ ██    ██ ██   ██ ███████ 
    #  ██  ██  ██ ██      ██ ███ ██     ██  ██  ██ ██         ██    ██   ██ ██    ██ ██   ██      ██ 
    #   ████   ██ ███████  ███ ███      ██      ██ ███████    ██    ██   ██  ██████  ██████  ███████ 

    # developers

    def layout(name = :layout, format = :html, renderer = :erb, view)
      _view_mapper.set_layout(name, format, renderer, view)
    end

    def wrapper(name = :wrapper, format = :html, renderer = :erb, view)
      _view_mapper.set_wrapper(name, format, renderer, view)
    end

    def template(name, format = :html, renderer = :erb, view)
      _view_mapper.set_template(name, format, renderer, view)
    end

    def content(name, format = :html, renderer = :erb, view)
      _view_mapper.set_content(name, format, renderer, view)
    end

    # framework

    def _view_mapper
      @view_mapper ||= ViewMapper.new
    end

    # BOTTOM-UP:
    # RootRequest
    # AppRequest
    # Tio::WebRequest
    def _view_mappers
      @view_mappers ||=  ancestors.select { |c| c.respond_to?(:_view_mapper) }
                                    .map(&:_view_mapper)
    end

    def _get_views(name, format)
      # @view_cache["#{name}.#{format}"] ||= 
      layout = nil
      wrapper = nil
      template = nil

      _view_mappers.each do |vm|
        layout ||= vm.get_layout(name, format) || vm.get_layout(:layout, format)
        wrapper ||= vm.get_wrapper(name, format) || vm.get_wrapper(:wrapper, format)
        template ||= vm.get_template(name, format) || vm.get_template(:template, format)
      end

      [layout, wrapper, template]
    end

    def _get_content(name, format)
      _view_mappers.each do |vm|
        x = vm.get_content(name, format)
        return x if x
      end

      nil
    end
  end
end
