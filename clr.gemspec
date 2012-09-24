# -*- encoding: utf-8 -*-
require File.expand_path('../lib/clr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["lefty313"]
  gem.email         = ["lewy313@gmail.com"]
  gem.description   = %q{This gem manages the markers for debugging}
  gem.summary       = %q{This gem manages the markers for debugging}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "clr"
  gem.require_paths = ["lib"]
  gem.version       = Clr::VERSION

  gem.add_dependency "thor"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "fuubar"
  gem.add_development_dependency 'rb-inotify', '~> 0.8.8'
end
