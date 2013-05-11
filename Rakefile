require "bundler/gem_tasks"

task :default => :start

desc "start the bjork server"
task :start do
  require "bjork"

  Bjork::Server.run!
end
