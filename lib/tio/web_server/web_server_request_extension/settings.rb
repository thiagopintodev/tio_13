module Tio::WebServerRequestExtension
  class Settings
    def initialize
      @router = Router.new
    end

    attr_reader :router

    def request(class_name, *recipes, &block)
      @request_class_name = class_name.to_s
      @request_class = _request_constantize(@request_class_name)

      recipes.each do |recipe|
        send("route_recipe_#{recipe}")
      end

      instance_eval(&block) if block_given?

      @request_class = nil
    end

    def _request_constantize(class_name)
      "#{class_name.to_s.camelize}Request".constantize
    end

    def route(path, get_action_name, post_action_name = get_action_name)
      String.argument_error path
      Symbol.argument_error get_action_name
      Symbol.argument_error post_action_name

      @router.add(@request_class, @request_class_name, path, get_action_name, post_action_name)
    end

    # these should be included from a module
    def route_recipe_rest_13(name)
      plural = name.pluralize
      singular = name.singularize
      
      route "/#{plural}", :list
      route "/#{plural}/search", :search
      route "/#{plural}/create", :creating, :create
      route "/#{plural}/update", :updating, :update
      route "/#{plural}/clear",  :clearing, :clear
      route "/#{plural}/@#{singular}_id",        :read
      route "/#{plural}/@#{singular}_id/edit",   :editing,  :edit
      route "/#{plural}/@#{singular}_id/remove", :removing, :remove
    end
  end
end
