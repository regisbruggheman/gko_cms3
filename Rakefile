#!/usr/bin/env rake 
require "rubygems"
require "bundler"
Bundler.setup
Dir[File.expand_path('../tasks/**/*', __FILE__)].each do |task|
  load task
end
desc "Build gem files for all projects"
task :build => "all:build"

