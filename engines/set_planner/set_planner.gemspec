$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "set_planner/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "set_planner"
  s.version     = SetPlanner::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "https://gospeltoolbox.org"
  s.summary     = "Set planning app"
  s.description = "Set planning app"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6", ">= 5.1.6.1"
  s.add_dependency "jquery-rails"
  s.add_dependency 'pg', '~> 1.1'

end
