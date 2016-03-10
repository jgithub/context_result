require File.dirname(__FILE__) + "/lib/context_result/version"

Gem::Specification.new do |s|
  s.name             = "catamaran"
  s.version          = Catamaran::VERSION
  s.authors          = ["Jeano"]
  s.email            = ["catamaran@jeano.net"]
  s.summary          = "Context Result"
  s.description      = "Context Result"
  s.homepage         = "http://github.com/jgithub/context_result"
  s.files            = `git ls-files`.split("\n")
  s.licenses         = ['MIT']

  s.add_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'timecop'
end
