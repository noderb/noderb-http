require File.expand_path("../lib/noderb/modules/http/version", __FILE__)

Gem::Specification.new do |s|
  
  s.name        = "noderb-http"
  s.version     = NodeRb::Modules::Http::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marek Jelen"]
  s.email       = ["marek@jelen.biz"]
  s.homepage    = "http://github.com/noderb/noderb-http"
  s.summary     = "Fast and full-featured HTTP parser"
  s.description = "Fast and full-featured HTTP parser."

  s.required_rubygems_version = ">= 1.3.6"

  s.extensions << 'ext/noderb_http_extension/extconf.rb'

  s.add_dependency('rack', '>= 1.1.0')

  s.files        = Dir.glob("{bin,lib,ext,test}/**/*") + %w(LICENSE README.md)

  s.require_paths = ['lib']
  
end