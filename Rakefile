desc "Build and push gh-pages"
task :build do
  sh "bundle exec middleman build --clean"
  sh "cd build && git add . && git ci -am 'build' && git push"
end
