require "bjork"

module Bjork
  module Tasks
    extend Rake::DSL

    def self.install
      desc "Start the development server"
      task :start do
        Bjork::Server.run!
      end
    end
  end
end

Bjork::Tasks.install
