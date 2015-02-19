# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unsound/version'

Gem::Specification.new do |spec|
  spec.name          = "unsound"
  spec.version       = Unsound::VERSION
  spec.authors       = ["Peter Swan"]
  spec.email         = ["pdswan@gmail.com"]
  spec.summary       = %q{General functional concepts inspired by Haskell, implemented in Ruby.}
  spec.homepage      = "https://github.com/pdswan/unsound"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "concord", "~> 0"
  spec.add_dependency "abstract_type", "~> 0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 0"
end
