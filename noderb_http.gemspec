Gem::Specification.new do |s|
  s.name        = "noderb_http"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marek Jelen"]
  s.email       = ["marek@jelen.biz"]
  s.homepage    = "http://github.com/marekjelen/noderb"
  s.summary     = "Libuv (the core of NodeJS) ported to ruby"
  s.description = "Well ... this is my first c-based gem, so I still polish it privately, if anyone interested, feel free to contact me."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bundler"

#  s.add_development_dependency "rspec"

#  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
#  s.executables  = ['bundle']
  s.require_path = 'lib'
end