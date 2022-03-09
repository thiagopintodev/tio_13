require "zeitwerk"

# loader.collapse("#{__dir__}/booking/actions")
# loader.collapse("#{__dir__}/*/actions")

# https://github.com/fxn/zeitwerk
loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib")
# loader.push_dir("#{__dir__}/lib/tio/web")
# loader.push_dir("#{__dir__}/lib")

loader.collapse("#{__dir__}/lib/tio/web")
loader.collapse("#{__dir__}/lib/tio/web_server")

loader.push_dir("#{__dir__}/app")
# loader.push_dir("#{__dir__}/app/web")
loader.push_dir("#{__dir__}/app/web/requests")
# loader.push_dir("#{__dir__}/app/work")
# loader.push_dir("#{__dir__}/app/terminal")



# loader.inflector.inflect(
#   "html_parser"   => "HTMLParser",
#   "mysql_adapter" => "MySQLAdapter"
# )

# loader.inflector.inflect "html_parser" => "HTMLParser"

loader.enable_reloading # you need to opt-in before setup
loader.setup # ready!
$loader = loader

def reload!
  $loader.reload
end

def r!
  reload!
end

# loader.reload
loader.eager_load





# binding.irb
# exit
