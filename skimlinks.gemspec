# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'skimlinks/version'

Gem::Specification.new do |gem|
  gem.name          = 'skimlinks'
  gem.version       = Skimlinks::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.author        = 'Manuel Meurer'
  gem.email         = 'manuel@krautcomputing.com'
  gem.summary       = 'A simple wrapper around the Skimlinks APIs'
  gem.description   = 'A simple wrapper around the Skimlinks APIs'
  gem.homepage      = 'https://manuelmeurer.github.io/skimlinks'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r(^bin/)).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r(^(test|spec|features)/))
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  # gem.add_development_dependency 'webmock'
  # gem.add_development_dependency 'vcr'
  # gem.add_development_dependency 'ffaker'
  # gem.add_development_dependency 'rb-fsevent'
  # gem.add_development_dependency 'guard'
  # gem.add_development_dependency 'guard-rspec'

  gem.add_runtime_dependency 'gem_config'
  gem.add_runtime_dependency 'mechanize'
  # gem.add_runtime_dependency 'rest-client'
  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'activemodel'
  gem.add_runtime_dependency 'httparty'

  # if RUBY_PLATFORM == 'java'
  #   gem.add_runtime_dependency 'json-jruby'
  #   gem.add_runtime_dependency 'jruby-openssl'
  # end
end
