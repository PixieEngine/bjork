# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bjork/version'

Gem::Specification.new do |spec|
  spec.name          = "bjork"
  spec.version       = Bjork::VERSION
  spec.authors       = ["Daniel Moore"]
  spec.email         = ["yahivin@gmail.com"]
  spec.description   = %q{A magical singing HTML5 game server}
  spec.summary       = %q{A magical singing HTML5 game server}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "sinatra"
  spec.add_dependency "coffee-script"
  spec.add_dependency "haml"
  spec.add_dependency "sprockets"
  spec.add_dependency "shank"
  spec.add_dependency "jquery-source", "1.9.1.1"
end
