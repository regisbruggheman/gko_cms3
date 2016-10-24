# Encoding: UTF-8
$:.push File.expand_path('../../gko_core/lib', __FILE__)
require 'gko/version'

version = Gko.version

Gem::Specification.new do |s|
  s.name = "gko_auth"
  s.version = version
  s.authors = ["rb"]
  s.email = "contact@joufdesign.com"
  s.homepage = "http://joufdesign.com"
  s.summary = "Core engine for gko cms"
  s.description = "Core engine for gko cms"

  s.files = Dir['{app,config,lib,assets,db}/**/*']
  s.platform = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'devise', '~> 2.2.3'
  s.add_dependency 'cancan', '~> 1.6.10'
end
