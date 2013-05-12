require "thor"

module Bjork
  class CLI < Thor
    desc "version", "Show version"
    def version
      require "bjork/version"
      say "Bjork #{VERSION}"
    end

    desc "create NAME", "Create a project"
    def create(name)
      say "Creating #{name}"
      require "bjork/generator"

      Bjork::Generator.new([name]).invoke_all
    end

    desc "server", "Run your game!"
    def server
      require "bjork"

      Bjork::Server.run!
    end

    default_task :server
  end
end
