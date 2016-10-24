# TODO [cli] needs to use the local Gemfile if we're in an app
ENV['BUNDLE_GEMFILE'] = File.expand_path('../../../../Gemfile', __FILE__)

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

Gko.engines.each { |engine| engine.new.load_tasks }

if task = Thor::Util.find_by_namespace("gko:#{ARGV.first}")
  ARGV.shift
else
  task = Thor::Util.find_by_namespace("gko:app")
end

task.start
