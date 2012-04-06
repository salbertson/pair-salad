# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Scott Albertson"]
  gem.email         = ["salbertson@streamsend.com"]
  gem.description   = %q{Git utility used when pair programming.}
  gem.summary       = %q{Git utility used when pair programming.}
  gem.homepage      = ""

  gem.default_executable = %q{pair}
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pair-salad"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"
end
