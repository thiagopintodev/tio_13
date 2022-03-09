require_relative 'app'


puts "\n" * 3

# Tio
# Tio::VERSION
# Tio::WebServer


# WebServer

# Tio::WebRequest
# AppRequest
# RootRequest



app = $app

# DONE: An App instance and a WebServer instance

raise if app.web.class != WebServer


# DONE: WebServer class has a domain

raise if app.web.class.domain != 'tio.com'

# DONE: WebServer class has requests

# WebServer.singleton_methods
# => [:domain, :requests, :requests, :yaml_tag]

raise if WebServer.requests.is_not_a? Tio::WebServerRequestExtension::Settings
raise if app.web.class.requests.is_not_a? Tio::WebServerRequestExtension::Settings



# DONE: A WebServer class has a _mapper


raise if WebServer.requests.instance_eval('@router').is_not_a? Tio::WebServerRequestExtension::Router



# DONE: A Request class has one and many action mappers

raise if RootRequest._action_mapper.is_not_a? Tio::WebRequestExtension::ActionMapper
raise if UsersRequest._action_mapper.is_not_a? Tio::WebRequestExtension::ActionMapper
raise if RootRequest._action_mapper == UsersRequest._action_mapper
raise if RootRequest._action_mappers.count != 3


# DONE: A Request class has one and many view mappers

raise if RootRequest._view_mapper.is_not_a? Tio::WebRequestExtension::ViewMapper
raise if UsersRequest._view_mapper.is_not_a? Tio::WebRequestExtension::ViewMapper
raise if RootRequest._view_mapper == UsersRequest._view_mapper
raise if RootRequest._view_mappers.count != 3





# DONE: 3 Valid web.request basic DSLs supported

r1  =  app.web.request(:GET, '/users/123/edit')
r2  =  app.web.request.users.editing(123)
r3  =  app.web.request.users.edit(123)

puts r1
puts r2
puts r3

puts app.web.request
puts app.web.request.users
puts app.web.request.users.list.url
puts app.web.request.users.read(123).url
puts app.web.request.users.edit(123).url
# puts app.web.request.school_teachers.edit(1, 2)





# DONE: request.run renders and it ends in </div>

# request = app.web.class.requests.mapper.find(:GET, '/users/123/edit')

# request = app.web.request(:GET, '/users/123/edit')
# request = app.web.request(:GET, '/users/search').params(q: 'John')
# request = app.web.request(:GET, '/users')

# app.web.request(:GET, '/users/create').run
# app.web.request(:GET, '/users/create').run


raise unless app.web.request(:GET, '/users').run.end_with? "</html>"
raise unless app.web.request(:GET, '/users/search').run.end_with? "</html>"
raise unless app.web.request(:GET, '/users/create').run.end_with? "</html>"
raise unless app.web.request(:GET, '/users/update').run.end_with? "</html>"
raise unless app.web.request(:GET, '/users/clear').run.end_with? "</html>"
raise unless app.web.request(:GET, '/users/123').run.end_with? "</html>"
raise unless app.web.request(:GET, '/users/123/edit').run.end_with? "</html>"
raise unless app.web.request(:GET, '/users/123/remove').run.end_with? "</html>"




# DONE: Request._get_actions(name, format)

raise if UsersRequest._get_actions(:list, :html).count != 1
raise if UsersRequest._get_actions(:read, :html).count != 2





# DONE: Request._get_views(name, format)

raise if UsersRequest._get_views(:list, :html).count != 3
raise if UsersRequest._get_views(:read, :html).count != 3







r = app.web.request(:GET, '/users')

binding.irb

puts app.web.request(:GET, '/users').run
# puts app.web.request(:GET, '/users').run
# puts app.web.request(:GET, '/users').run

