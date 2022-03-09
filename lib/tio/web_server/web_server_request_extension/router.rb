# TODO: add more arity options
# https://apidock.com/ruby/Method/arity
class Tio::WebServerRequestExtension::Router
  def initialize
    @routes_to_request_classes = _new_node
    @request_classes_to_routes = {}
    @nav = Object.new

    # @nav.define_singleton_method(:get)  { @get  ||= Object.new }
    # @nav.define_singleton_method(:post) { @post ||= Object.new }

    # def @nav.get(path)
    #   ...
    # end
    # def @nav.post(path)
    #   ...
    # end
  end

  attr_reader :nav
  
  def _new_node
    {
      route: nil,
      class: nil,
      GET: nil,
      POST: nil
    }
  end

  
  # refine String do
  #   def to_safe_path
  #     cursor = [1..-1] while [0] == '/'

  #     cursor.split('?').first.to_s.split('#').first.to_s
  #   end
  # end

  def add(request_class, request_class_name, path, get_action_name, post_action_name)
    # puts "adding #{request_class}, '#{path}', :#{get_action_name}, :#{post_action_name}".cyan


    # path = path.to_safe_path
    path = path[1..-1] while path[0] == '/'

    path = path.split('?').first.to_s.split('#').first.to_s

    params_array = []






    # @routes_to_request_classes          

    cursor = @routes_to_request_classes

    path.split('/').each do |fragment|
      if fragment[0] == '@'
        cursor[:param] = fragment
        params_array << fragment
      end
      
      cursor = cursor[fragment] ||= _new_node
    end

    # TODO: decide if I should rename all path to route in this method (or class)
    route = path

    cursor[:GET] = get_action_name
    cursor[:POST] = post_action_name
    cursor[:route] = route
    cursor[:class] = request_class
    cursor[:params_array] = params_array







    # @request_classes_to_routes

    common = {
      route: path,
      params_array: params_array
    }

    cursor = @request_classes_to_routes

    cursor["#{request_class}_#{get_action_name}"]  ||= common.merge method: :GET
    cursor["#{request_class}_#{post_action_name}"] ||= common.merge method: :POST





    # @nav

    cursor = @nav

    klass_object = Object.new
    if !cursor.respond_to? request_class_name
      cursor.define_singleton_method(request_class_name) { klass_object }
    end
    cursor = cursor.send(request_class_name)

    format = :html

    _add_to_object(cursor, get_action_name, request_class, :GET, params_array, route, format)
    _add_to_object(cursor, post_action_name, request_class, :POST, params_array, route, format)

    # TODO: add get and post to nav?

    # def @navigator.get
    # end

    # def @navigator.post
    # end
  end

  def _add_to_object(cursor, action_name, request_class, http_method, params_array, route, format)
    cursor.define_singleton_method(action_name) do |*args|
      args.size == params_array.size || raise(ArgumentError, "Expected #{params_array.size} arguments, but #{args.size} received for #{route}")

      params_hash = {}
      args.size.times do |i|
        params_hash[params_array[i]] = args[i]
      end

      path = route.split('/').map { |fragment| fragment[0] == '@' ? params_hash[fragment] : fragment }.join('/')

      # building a request #1 #2
      request_class.new(http_method, path, action_name, format, params_hash)
    end
  end

  def find_by_path(http_method, path)
    # [:GET, :POST].argument_error http_method

    # to_safe_path
    path = path[1..-1] while path[0] == '/'
    path = path.split('?').first.to_s.split('#').first.to_s.split('.').first.to_s

    cursor = @routes_to_request_classes

    params_hash = {}

    path.split('/').each do |fragment|
      fragment = fragment[1..-1] while fragment[0] == '@'

      if cursor[fragment]
        cursor = cursor[fragment]
      elsif cursor[:param]
        param = cursor[:param]
        params_hash[param] = fragment

        cursor = cursor[param]
      else
        raise "path #{path} not found. stopped at `#{fragment}`"
      end

    end

    raise "Can't find a URL match to `#{path}.`" if cursor.nil?
    raise "Can't find a URL match to `#{path}..`" if cursor[:class].nil?

    # CHECK: cursor.keys == [:route, :class, :GET, :POST]

    klass = cursor[:class]
    action_name = cursor[http_method]

    # building a request #3
    klass.new(http_method, path, action_name, :html, params_hash)
  end

  def find_by_action(klass, action_name, params_array)
    # MAY RAISE
    klass = klass.to_s if klass.is_a? Symbol
    klass = "#{klass.camelize}Request".constantize if klass.is_a? String

    raise "Could not resolve '#{klass}' to a Class" if klass.is_not_a? Class
    raise "Could not resolve '#{klass}' to a Request Class" if klass.ancestors.doesnt_include? WebServer::Request

    # klass

    # klass.has_action?(action_name) or raise("#{klass} does not include an action #{action_name}")

    # klass, action_name


    cursor = @request_classes_to_routes
    cursor = cursor["#{klass}_#{action_name}"]
    
    # {method: :GET,  path: path, params: ['@user_id']}
    params_hash = {}

    cursor[:params_array].each_with_index do |param, i|
      params_hash[param] = params_array[i]
    end

    route = []

    cursor[:route].split('/').each do |fragment|
      # route << fragment[0] != '@' ? fragment : params[fragment]
      route << if fragment[0] != '@'
              fragment
            else
              params_hash[fragment]
            end
    end
    route = route.join('/')

    format = :html

    # building a request #4
    klass.new(cursor[:method], route, action_name, format, params_hash)
  end

end
