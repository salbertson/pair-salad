# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = %q{pair-salad}
  gem.authors       = ["Scott Albertson"]
  gem.email         = ["salbertson@streamsend.com"]
  gem.description   = %q{Git utility used when pair programming.}
  gem.summary       = %q{Git utility used when pair programming.}
  gem.homepage      = ""

  gem.default_executable = %q{pair-salad}
  gem.files         = ["Rakefile", "README.md", "bin/pair-salad"]
  gem.executables   = ["pair-salad"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pair-salad"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("ruby-debug")
end
