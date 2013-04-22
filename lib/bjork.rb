require "bjork/version"
require "sinatra"
require 'coffee-script'
require "haml"
require "sprockets"
require "cornerstone-source"

module Bjork
  class Server < Sinatra::Base
    local_folder = File.expand_path(File.dirname(__FILE__))

    set :assets, Sprockets::Environment.new

    # TODO: Serve up game assets from external directory

    # Configure sprockets
    settings.assets.append_path "#{local_folder}/javascripts"
    settings.assets.append_path "#{local_folder}/stylesheets"

    set :public_folder, local_folder

    set :haml, { :format => :html5 }

    get "/" do
      haml :index
    end

    get "/javascripts/:file.js" do
      content_type "application/javascript"
      settings.assets["#{params[:file]}.js"]
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
