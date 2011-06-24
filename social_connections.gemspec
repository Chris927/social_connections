# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "social_connections/version"

Gem::Specification.new do |s|
  s.name        = "social_connections"
  s.version     = SocialConnections::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris"]
  s.email       = ["christian.oloff+gem@gmail.com"]
  s.homepage    = "https://sites.google.com/site/socialconnections7/"
  s.summary     = %q{Social connections for ActiveRecord.}
  s.description = %q{The idea is to provide pluggable social connections, activities and a method to digest those activities (e.g. in daily emails).}

  s.rubyforge_project = "social_connections"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
#  s.test_files.reject! { |fn| fn.include? ".swp" }
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
