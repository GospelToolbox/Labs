$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "set_live/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "set_live"
  s.version     = SetLive::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "https://gospeltoolbox.org"
  s.summary     = "Worship Set Live app"
  s.description = "Worship Set Live app"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,public}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6", ">= 5.1.6.1"
  s.add_dependency "webpacker", "~> 4.x"
  s.add_dependency "jquery-rails"

end
