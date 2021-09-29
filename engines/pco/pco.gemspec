$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pco/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pco"
  s.version     = PCO::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "https://gospeltoolbox.org"
  s.summary     = "Planning Center Gospel Toolbox Interface"
  s.description = "Planning Center Gospel Toolbox Interface"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1"
  s.add_dependency 'pco_api'
  s.add_dependency 'api_cache'
  s.add_dependency 'oauth2'
  s.add_dependency 'pg', '~> 1.1'
end
