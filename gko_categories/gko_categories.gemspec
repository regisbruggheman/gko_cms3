# Encoding: UTF-8
$:.push File.expand_path('../../gko_core/lib', __FILE__)
require 'gko/version'

version = Gko.version

Gem::Specification.new do |s|
  s.name = "gko_categories"
  s.version = version
  s.authors = ["rb"]
  s.email = "contact@joufdesign.com"
  s.homepage = "http://joufdesign.com"
  s.summary = "Asset engine for gko cms"
  s.description = "Asset engine for gko cms"

  s.files = Dir['{app,config,lib,public}/**/*']
  s.platform = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  #s.add_dependency 'gko_core', version
end
