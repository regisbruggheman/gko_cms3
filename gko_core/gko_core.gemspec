# Encoding: UTF-8
$:.push File.expand_path('../../gko_core/lib', __FILE__)
require 'gko/version'

version = Gko.version

Gem::Specification.new do |s|
  s.name = "gko_core"
  s.version = Gko.version
  s.authors = ["rb"]
  s.email = "contact@joufdesign.com"
  s.homepage = "http://joufdesign.com"
  s.summary = "Core engine for gko cms"
  s.description = "Core engine for gko cms"
  s.files = Dir['{app,config,lib,public}/**/*']
  s.platform = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.add_dependency 'rails', '= 3.2.22'
  s.add_dependency 'bundler', '~> 1.3'
  s.add_dependency 'net-ssh', '= 2.0.14' # no more support for ruby 1.8.7 after 2.5.1
  s.add_dependency 'i18n', '~> 0.6.4'
  s.add_dependency 'rake', '~> 10.1.1'
  s.add_dependency 'mysql2', '~> 0.3.14'
  s.add_dependency 'json', '~> 1.8.1'
  s.add_dependency 'rack-mount', '~> 0.8.3' 
  s.add_dependency 'rack-cache', '= 1.2'
  s.add_dependency 'coffee-rails', '~> 3.2.2'
  s.add_dependency 'sass-rails', '~> 3.2.6'
  s.add_dependency 'uglifier', '~> 2.4.0'
  s.add_dependency 'jquery-rails', '= 2.0.3' #2.0.3 for jquery 1.7.2
  s.add_dependency 'highline', '~> 1.6.20'
  s.add_dependency 'activesupport-slices', '0.0.2'
  s.add_dependency 'will_paginate', '~> 3.0.2'
  s.add_dependency 'babosa', '~> 0.3.8'
  s.add_dependency 'globalize', '~> 3.1.0'
  s.add_dependency 'gem-patching', '0.0.3'
  s.add_dependency 'inherited_resources', '~> 1.3.1'
  s.add_dependency 'has_scope', '~> 0.5.1'
  s.add_dependency 'routing-filter', '0.3.1'
  s.add_dependency 'dragonfly', '~> 0.9.15'
  s.add_dependency 'cucumber', '~> 1.1.4'
  s.add_dependency 'rmagick'#, '= 2.13.2'
  s.add_dependency 'carrierwave', '~> 0.9.0'
  s.add_dependency 'simple_form', '~> 2.1.1'
  s.add_dependency 'nested_set', '~> 1.7.1'
  s.add_dependency 'uuid', '~> 2.3.7'
  s.add_dependency 'acts_as_indexed', '~> 0.7.7'
  s.add_dependency 'truncate_html', '= 0.5.5' # no more support for ruby 1.8.7 after 0.9 version
  s.add_dependency 'capistrano', '~> 2.14'
  s.add_dependency 'exception_notification', '~> 3.0.0'
  s.add_dependency 'rubyzip', '= 0.9.6.1'
  #s.add_dependency 'RedCloth', '4.2.9'
  s.add_dependency 'codemirror-rails', '>= 2.3'
  #s.add_dependency 'nokogiri', '~> 1.5.0'
  s.add_dependency 'mail_form', '~> 1.3.0'
  s.add_dependency 'to_xls', '~> 1.5.1'
  #s.add_dependency 'therubyracer'
  s.add_dependency 'execjs', '= 2.0.2' # no more support for ruby 1.8.7 after
  s.add_dependency 'country_select', '~> 1.2.0'
  s.add_dependency 'letter_opener', '~> 1.1.1'
  s.add_development_dependency 'lol_dba', '~> 1.6.0' #to check db indexes
  s.add_dependency 'faker', '~> 1.2.0'
  s.add_dependency 'mobvious', '~> 0.3.2'
  s.add_dependency 'addressable', '= 2.3.8'
  s.add_dependency 'tins', '= 1.6.0'
  s.add_dependency 'summernote-rails', '~> 0.7.1.0'
end
