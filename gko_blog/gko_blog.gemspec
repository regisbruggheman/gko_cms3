# Encoding: UTF-8
$:.push File.expand_path('../../gko_core/lib', __FILE__)
require 'gko/version'

version = Gko.version.to_s

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "gko_blog"
  s.version = version
  s.authors = ["Regis Bruggheman"]
  s.email = "regis@joufdesign.com"
  s.homepage = "http://joufdesign.com"
  s.summary = "Blog extension for gko CMS"
  s.description = "Blog extension for gko CMS - v #{s.version}"
  s.files = `git ls-files`.split("\n")
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

end
