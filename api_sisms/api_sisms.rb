require 'yaml'
require 'will_paginate'

class ApiSisms < Sinatra::Application
  use Rack::Session::EncryptedCookie,
    secret: '817a7d8a360918ab78deb96142f1b2c09876ae91595e8f79965b8e8225b27def'

  set :app_file, __FILE__
  set :server, :puma
  set :views, Proc.new { File.join(root, "app/views") }
  set :assets, Sprockets::Environment.new
  set :assets_manifest, %w(app.js app.css)
  # use Rack::Csrf, raise: false

  register WillPaginate::Sinatra
  register Sinatra::CrossOrigin

  configure do
    Sequel::Database.extension :pagination
    Sequel::Model.plugin :timestamps
    # Sequel::Model.plugin :json_serializer
    Sequel::Model.plugin :auto_validations,
      not_null: :presence, unique_opts: { only_if_modified: true }

    enable :cross_origin

    set :allow_origin, "*" # allows any origin(domain) to send fetch requests to your API
    set :allow_methods, [:get, :post, :patch, :delete, :options] # allows these HTTP verbs
    set :allow_credentials, true
    set :max_age, 1728000
    set :expose_headers, ['Content-Type']

    assets.append_path 'assets/stylesheets'
    assets.append_path 'assets/javascripts'
  end

  options '*' do
    response.headers["Allow"] = "HEAD,GET,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    200
  end

  configure :development do
    require 'sinatra/reloader'
    require 'logger'

    register Sinatra::Reloader
    Sequel.connect YAML.load_file(File.expand_path("../config/database.yml", __FILE__))['development'],
      loggers: [Logger.new($stdout)]

    get '/assets/*' do
      env['PATH_INFO'].sub!('/assets', '')
      settings.assets.call(env)
    end
  end

  configure :test do
    Sequel.connect YAML.load_file(File.expand_path("../config/database.yml", __FILE__))['test']
  end

  configure :production do
    # Serve assets via Nginx or Apache
    disable :static

    assets.js_compressor  = :uglify
    assets.css_compressor = :sass
    Sequel.connect YAML.load_file(File.expand_path("../config/database.yml", __FILE__))['production']
  end
end
