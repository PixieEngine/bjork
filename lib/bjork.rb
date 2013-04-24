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

    # TODO: Add a file cache to speed up sproco
    set :assets, Sprockets::Environment.new

    # Configure sprockets
    settings.assets.append_path "#{local_folder}/javascripts"
    settings.assets.append_path "#{local_folder}/stylesheets"

    # External Sources
    settings.assets.append_path "source"

    set :public_folder, local_folder

    set :haml, { :format => :html5 }

    get "/" do
      haml :index
    end

    get "/javascripts/*.*" do
      content_type "application/javascript"

      path, extension = params[:splat]

      settings.assets["#{path}.#{extension}"]
    end

    get "/stylesheets/:file.css" do
      content_type "text/css"
      settings.assets["#{params[:file]}.css"]
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
