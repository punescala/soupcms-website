require 'tilt'
require 'sprockets'

require 'soupcms/core'
require 'soupcms/api'

SoupCMS::Common::Strategy::Application::SingleApp.configure do |app|
  app.app_name = "punescala"
  app.display_name = "Scala community in and around Pune"

  if ENV['RACK_ENV'] == 'production'
    app.soupcms_api_url = 'http://punescala.herokuapp.com/api'
    app.app_base_url = 'http://punescala.herokuapp.com/'
  else
    app.soupcms_api_url = 'http://localhost:9292/api'
    app.app_base_url = 'http://localhost:9292/'
  end

end

map '/api' do
  SoupCMSApi.configure do |config|
    config.application_strategy = SoupCMS::Common::Strategy::Application::SingleApp
    config.data_resolver.register(/content$/,SoupCMS::Api::Resolver::KramdownMarkdownResolver)
  end
  run SoupCMSApiRackApp.new
end

PUBLIC_DIR = File.join(File.dirname(__FILE__), 'public')
map '/assets' do
  sprockets = SoupCMSCore.config.sprockets
  sprockets.append_path PUBLIC_DIR
  sprockets.append_path SoupCMS::Core::Template::Manager::DEFAULT_TEMPLATE_DIR
  run sprockets
end

map '/' do
  SoupCMSCore.configure do |config|
    config.application_strategy = SoupCMS::Common::Strategy::Application::SingleApp
  end
  soup_cms_rack_app = SoupCMSRackApp.new

  soup_cms_rack_app.set_redirect('http://punescala.herokuapp.com','http://punescala.herokuapp.com/home')
  soup_cms_rack_app.set_redirect('http://punescala.herokuapp.com/','http://punescala.herokuapp.com/home')

  run soup_cms_rack_app
end


