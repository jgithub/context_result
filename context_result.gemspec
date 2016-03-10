require File.dirname(__FILE__) + "/lib/context_result/version"

Gem::Specification.new do |s|
  s.name             = "context_result"
  s.version          = VERSION
  s.authors          = ["Jeano"]
  s.email            = ["github@jeano.net"]
  s.summary          = "Context Result"
  s.description      = "Context Result"
  s.homepage         = "http://github.com/jgithub/context_result"
  s.files            = `git ls-files`.split("\n")
  s.licenses         = ['MIT']

  s.add_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'pry'
end
