# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
unless $LOAD_PATH.map { |path| File.expand_path(path, Dir.pwd) }.include?(lib)
  $LOAD_PATH.unshift(lib)
end

require 'Radiate360/version'

Gem::Specification.new do |gem|
  gem.name          = 'Radiate360'
  gem.version       = Radiate360::VERSION
  gem.authors       = ['Radiate Media']
  gem.homepage      = 'https://github.com/radiatemedia/Radiate360'
  gem.summary       = 'Wrapper library for the Radiate 360 API'
  gem.description   = <<-DESC.gsub(/^\s*/, '')
    Implements the Radiate360 api'
  DESC

  gem.files         = `git ls-files`.split($\)
  gem.require_paths = ['lib']

  gem.add_development_dependency 'json' # use more efficient parser during development
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler',    '~> 1.0'
  gem.add_development_dependency 'rspec',      '~> 2.11.0'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'geminabox'

  gem.add_runtime_dependency "multi_json", '~> 1.3.6'
  gem.add_runtime_dependency "activesupport"
end
