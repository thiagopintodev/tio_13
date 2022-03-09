module Tio
  module WebRequestExtension
    class ViewMapper
      def initialize
        @layouts   = {}
        @wrappers  = {}
        @templates = {}
        @contents  = {}

        # @default_layout = :layout
        # @default_wrapper = :wrapper
      end

      def set_layout(name, format, renderer, view)
        _valid_set(format, renderer)

        @layouts[name] ||= {}
        @layouts[name][format] = _view(renderer, view)
      end

      def set_wrapper(name, format, renderer, view)
        _valid_set(format, renderer)

        @wrappers[name] ||= {}
        @wrappers[name][format] = _view(renderer, view)
      end

      def set_template(name, format, renderer, view)
        _valid_set(format, renderer)

        @templates[name] ||= {}
        @templates[name][format] = _view(renderer, view)
      end

      def set_content(name, format, renderer, view)
        _valid_set(format, renderer)

        @contents[name] ||= {}
        @contents[name][format] = _view(renderer, view)
      end

      def get_layout(name, format)
        _valid_get(format)

        @layouts.dig(name, format)
      end

      def get_wrapper(name, format)
        _valid_get(format)

        @wrappers.dig(name, format)
      end

      def get_template(name, format)
        _valid_get(format)

        @templates.dig(name, format)
      end

      def get_content(name, format)
        _valid_get(format)

        @contents.dig(name, format)
      end

      private

      def _view(renderer, view)
        {renderer: renderer, view: view}
      end

      def _valid_set(format, renderer)
        VALID_FORMATS.argument_error(format)
        VALID_RENDERERS.argument_error(renderer)
      end

      def _valid_get(format)
        VALID_FORMATS.argument_error(format)
      end
    end
  end
end