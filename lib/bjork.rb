require "bjork/version"

require "sinatra/base"

require 'coffee-script'
require "haml"

require "sprockets"

require "shank"
require "jquery-source"

# Defaulting to bare compilation
Tilt::CoffeeScriptTemplate.default_bare = true

module Bjork
  class Server < Sinatra::Base
    local_folder = File.expand_path(File.dirname(__FILE__))

    asset_environment = Sprockets::Environment.new
    asset_environment.cache = Sprockets::Cache::FileStore.new("tmp")

    set :assets, asset_environment

    # Configure sprockets
    settings.assets.append_path "#{local_folder}/javascripts"
    settings.assets.append_path "#{local_folder}/stylesheets"

    # TODO: Consider asset gems
    # TODO: How to serve all folders?
    use Rack::Static, :urls => %w[
      /docs
      /images
      /levels
      /music
      /sounds
    ]

    # External Sprockets Source directories
    %w[
      data
      lib
      source
    ].each do |path|
      settings.assets.append_path path
    end

    set :public_folder, local_folder

    set :haml, { :format => :html5 }

    get "/" do
      haml :index
    end

    get '/debug_console' do
      haml :debug
    end

    post '/debug_console' do
      begin
        eval(params[:text]).inspect
      rescue Exception => e
        ([e.message] + e.backtrace).join("\n")
      end
    end

    %w[
      data
      javascripts
      stylesheets
    ].each do |dir|
      get "/#{dir}/*.*" do
        path, extension = params[:splat]

        if asset = settings.assets["#{path}.#{extension}"]
          content_type extension
          asset
        else
          status 404
        end
      end
    end

    # Any post to /save will write data to the path provided.
    post '/save' do
      data = params["data"]
      path = params["path"]

      # Ensure directory exists
      FileUtils.mkdir_p File.dirname(path)

      File.open(path, 'w') do |file|
        file.write(data)
      end

      200
    end
  end
end
