# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linedump/version'

Gem::Specification.new do |spec|
  spec.name          = "linedump"
  spec.version       = Linedump::VERSION
  spec.authors       = ["Ignacio Baixas"]
  spec.email         = ["ignacio@platan.us"]
  spec.summary       = %{Process output stream listener helper}
  spec.description   = %{linedump allows you to register blocks to consume live output streams, line by line.}
  spec.homepage      = "https://github.com/platanus/linedump-gem"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rspec-nc", "~> 0.2"
  spec.add_development_dependency "guard", "~> 2.11"
  spec.add_development_dependency "guard-rspec", "~> 4.5"
  spec.add_development_dependency "terminal-notifier-guard", "~> 1.6", ">= 1.6.1"
end
