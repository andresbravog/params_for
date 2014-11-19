# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'params_for/version'

Gem::Specification.new do |spec|
  spec.name          = "params_for"
  spec.version       = ParamsFor::VERSION
  spec.authors       = ["andresbravog"]
  spec.email         = ["andresbravog@gmail.com"]
  spec.summary       = %q{Params Validatior for controllers using active_model validations.}
  spec.description   = %q{With Params validator oyu should be able to perform controller params validation easy and with any kind of type, format, or custom validation you already know and use in oyur models. }
  spec.homepage      = "https://github.com/andresbravog/params_for"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel"
  spec.add_dependency "activesupport"

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'actionpack', '>= 3.0.0'
  spec.add_development_dependency 'railties', '>= 3.0.0'
end
