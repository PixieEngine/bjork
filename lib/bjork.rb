require "bjork/version"

require "sinatra"

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
    asset_environment.cache = Sprockets::Cache::FileStore.new("/tmp")

    set :assets, asset_environment

    # Configure sprockets
    settings.assets.append_path "#{local_folder}/javascripts"
    settings.assets.append_path "#{local_folder}/stylesheets"

    # External Sprockets Source directories
    %w[
      data
      images
      music
      sounds
      source
    ].each do |path|
      settings.assets.append_path path
    end

    set :public_folder, local_folder

    set :haml, { :format => :html5 }

    get "/" do
      haml :index
    end

    get "/docs" do
      documentation_dir = "#{local_folder}/documentation"

      haml "#{documentation_dir}/index.html"
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
      images
      javascripts
      music
      sounds
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

    # TODO: handle saving directory
    # post '/levels' do
    #   data = params["data"]
    #   name = params["name"]

    #   File.open("levels/#{name}.json", 'w') do |file|
    #     file.write(data)
    #   end

    #   200
    # end
  end
end
