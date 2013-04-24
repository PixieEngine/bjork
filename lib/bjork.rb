require "bjork/version"

require "sinatra"

require 'coffee-script'
require "haml"

require "sprockets"

require "pixie_dust"
require "jquery-source"

module Bjork
  class Server < Sinatra::Base
    local_folder = File.expand_path(File.dirname(__FILE__))

    set :assets, Sprockets::Environment.new

    # TODO: Serve up game assets from external directory

    # Configure sprockets
    settings.assets.append_path "#{local_folder}/javascripts"
    settings.assets.append_path "#{local_folder}/stylesheets"

    # Source Maps
    settings.assets.append_path "radical/source_maps"

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






















# Monkey patch some source maps
module CoffeeScript
  class << self
    def compile(script, options = {})
      script = script.read if script.respond_to?(:read)

      if options.key?(:no_wrap) && !options.key?(:bare)
        options[:bare] = options[:no_wrap]
      else
        options[:bare] = false
      end

      root_dir = Pathname("radical")

      pathname = options[:pathname]
      if pathname.nil?
        return Source.context.call("CoffeeScript.compile", script, options)
      else
        clean_name = pathname.basename.to_s.split(".").first

        rel_path = if pathname.to_s.start_with?(Bundler.bundle_path.to_s)
          Pathname('bundler').join(pathname.relative_path_from(Bundler.bundle_path)).dirname
        else
          pathname.relative_path_from(root_dir).dirname
        end

        chill_dir = root_dir.join("source_maps")
        map_dir = chill_dir.join(rel_path)
        map_dir.mkpath

        map_file    = map_dir.join("#{clean_name}.map")
        coffee_file = map_dir.join("#{clean_name}.coffee")

        options[:sourceMap] = true
        # coffee requires filename option to work with source maps (see http://coffeescript.org/documentation/docs/coffee-script.html#section-4)
        options[:filename] = "#{clean_name}.coffee"
        # specify coffee source file explicitly (see http://coffeescript.org/documentation/docs/sourcemap.html#section-8)
        options[:sourceFiles] = ["/#{coffee_file.relative_path_from(chill_dir)}"]
        ret = Source.context.call("CoffeeScript.compile", script, options)

        coffee_file.open('w') {|f| f.puts script }
        map_file.open('w')    {|f| f.puts ret["v3SourceMap"]}

        comment = "//@ sourceMappingURL=/#{map_file.relative_path_from(chill_dir)}\n"
        return ret['js'] + comment
      end

    end
  end
end

# Monkeypatch this method to include the scripts' pathname
require 'tilt/coffee'

module Tilt
  class CoffeeScriptTemplate < Template
    def evaluate(scope, locals, &block)
      pathname = scope.respond_to?(:pathname) ? scope.pathname : nil
      @output ||= CoffeeScript.compile(data, options.merge(:pathname => pathname))
    end
  end
end
