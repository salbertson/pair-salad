# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "pair-salad"
  gem.authors       = ["Scott Albertson"]
  gem.email         = ["salbertson@streamsend.com"]
  gem.summary       = %q{Handy gem for adding multiple authors to git commits.}
  gem.description   = %q{https://github.com/salbertson/pair-salad}
  gem.homepage      = "https://github.com/salbertson/pair-salad"

  gem.default_executable = %q{pair-salad}
  gem.files         = ["README.md", "lib/pair_salad_runner.rb", "bin/pair"]
  gem.executables   = ["pair"]
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.version       = "0.1.0"
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("debugger")
end
