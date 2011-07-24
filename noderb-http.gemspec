Gem::Specification.new do |s|
  
  s.name        = "noderb-http"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marek Jelen"]
  s.email       = ["marek@jelen.biz"]
  s.homepage    = "http://github.com/noderb/noderb-http"
  s.summary     = "Fast and full-featured HTTP parser"
  s.description = "Fast and full-featured HTTP parser."

  s.required_rubygems_version = ">= 1.3.6"

  s.extensions << 'ext/noderb_http_extension/extconf.rb'

  s.files        = Dir.glob("{bin,lib,ext}/**/*") + %w(LICENSE README.md)

  s.require_paths = ['lib', 'ext']
  
end