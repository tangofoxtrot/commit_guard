# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'commit_guard/version'

Gem::Specification.new do |gem|
  gem.name          = "commit_guard"
  gem.version       = CommitGuard::VERSION
  gem.authors       = ["Richard Luther"]
  gem.email         = ["richard.luther@gmail.com"]
  gem.description   = %q{Prevent unwanted code from being committed (sleep, debugger, bindin.pry). 
    Commit Guard allows the user to define custom rules at both the global and project level}
  gem.summary       = %q{Command line utility for preventing unwanted code from being committed}
  gem.homepage      = "http://github.com/tangofoxtrot/commit_guard"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'colorize'
  gem.add_dependency 'highline'
  gem.add_dependency 'commander'
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
end
