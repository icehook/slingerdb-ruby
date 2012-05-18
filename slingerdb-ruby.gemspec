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

  s.add_development_dependency 'rspec', ['>= 2.9.0']
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'ffaker', ['>= 1.13.0']
  s.add_runtime_dependency 'home_run', ['>= 1.0.6']
  s.add_runtime_dependency 'httparty', ['>= 0.8.1']
  s.add_runtime_dependency 'json', ['>= 1.7.1']
  s.add_runtime_dependency 'encryptor', ['>= 1.1.3']
end
