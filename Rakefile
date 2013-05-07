task :default => :build

desc "Build and push gh-pages"
task :build do
  sh "bundle exec middleman build --clean"
  sh "cd build && git add . && git ci -am 'build' && git push"
  sh "git add build && git ci -m 'built' && git push"
end
