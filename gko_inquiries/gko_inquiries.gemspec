# Encoding: UTF-8
$:.push File.expand_path('../../gko_core/lib', __FILE__)
require 'gko/version'

version = Gko.version

Gem::Specification.new do |s|
  s.name = "gko_inquiries"
  s.version = version
  s.authors = ["rb"]
  s.email = "contact@joufdesign.com"
  s.homepage = "http://github.com/joufdesign/gko-cms"
  s.summary = "[summary]"
  s.description = "[description]"

  s.files = Dir['{app,config,lib}/**/*']
  s.platform = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'filters_spam', '~> 0.2'
end