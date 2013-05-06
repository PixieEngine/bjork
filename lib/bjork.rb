require "bjork/version"
require "bjork/try_static"

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
    configure do
      enable :logging

      # Serve any assets that exist in our folders
      # Middlewares always take place before anything else,
      # so if the file exists locally in the following folders
      # it will be served.
      # If it is not found the request will continue to the rest of the app
      use Bjork::TryStatic, :urls => %w[/]

      asset_environment = Sprockets::Environment.new
      asset_environment.cache = Sprockets::Cache::FileStore.new("tmp")

      server_folder = File.expand_path(File.dirname(__FILE__))

      # Internal (bjork server) Sprockets asset directories
      %w[
        javascripts
        stylesheets
      ].each do |path|
        asset_environment.append_path File.join(server_folder, path)
      end

      # External (host app which is running bjork) Sprockets asset directories
      %w[
        lib
        source
      ].each do |path|
        asset_environment.append_path path
      end

      set :assets, asset_environment

      set :haml, { :format => :html5 }
    end

    get "/" do
      haml :index
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

    # Asset gems can use any of these four directories to
    # serve things up.
    # Try sprockets last
    %w[
      data
      images
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
  end
end
