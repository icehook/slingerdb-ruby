# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "slingerdb/version"

Gem::Specification.new do |s|
  s.name        = "slingerdb-ruby"
  s.version     = SlingerDB::VERSION
  s.authors     = ["klarrimore"]
  s.email       = ["klarrimore@icehook.com"]
  s.homepage    = "http://slinger.icehook.com"
  s.summary     = %q{A SlingerDB API client written in Ruby}
  s.description = %q{An API client for http://slinger.icehook.com}

  s.rubyforge_project = "."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_development_dependency 'rspec', '>= 2.9.0'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'ffaker', '>= 1.13.0'
  s.add_runtime_dependency 'home_run', '>= 1.0.6'
  s.add_runtime_dependency 'json', '>= 1.7.1'
  s.add_runtime_dependency 'encryptor', '>= 1.1.3'
  s.add_runtime_dependency 'multi_json', '~> 1.3.6'
  s.add_runtime_dependency 'multi_xml', '~> 0.5.1'
  s.add_runtime_dependency 'faraday', '~> 0.8.4'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.9.0'
  s.add_runtime_dependency 'faraday_middleware-multi_json', '~> 0.0.4'
  s.add_runtime_dependency 'oj', '~> 1.4.4'
  s.add_runtime_dependency 'activesupport', '>= 3.0.0'
  s.add_runtime_dependency 'em-http-request', '~> 1.0.3'
  s.add_runtime_dependency 'em-synchrony', '~> 1.0.2'
  s.add_runtime_dependency 'rash', '~> 0.3.2'
  s.add_runtime_dependency 'conformist', '~> 0.2.0'
  s.add_runtime_dependency 'hirb', '~> 0.7.0'
end
