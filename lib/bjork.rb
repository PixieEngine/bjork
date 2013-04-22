require "bjork/version"
require "sinatra"
require "haml"

module Bjork
  class Server < Sinatra::Base
    local_folder = File.expand_path(File.dirname(__FILE__))

    set :public_folder, local_folder

    set :haml, { :format => :html5 }

    get "/" do
      haml :index
    end

    get "/game.js" do
      ""
      # TODO: Use sprockets to serve assets?
      # TODO: Serve up game assets from external directory
    end

    get "/javascripts/jquery.min.js" do
      send_file File.join(local_folder, "javascripts", 'jquery.min.js')
    end

    get "/stylesheets/all.css" do
      send_file File.join(local_folder, "stylesheets", 'all.css')
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
