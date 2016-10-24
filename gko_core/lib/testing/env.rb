ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'bundler/setup'
Bundler.require

name = "#{File.basename(Dir.pwd)}-test"
app = Gko::Generators::App.new(name, :target => '/tmp', :migrate => true)
app.invoke

Gem.patching('webrat', '0.7.2') do
  ActionController.send(:remove_const, :AbstractRequest)
end

require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'
require 'webrat'
require 'webrat/core/matchers'
require 'patches/webrat/logger'
require 'test/unit/assertions'
require 'action_dispatch/testing/assertions'
require 'factory_girl'
require Gko::Core.root.join('lib/core_ext/rails/active_record/skip_callbacks')

Gko::Testing.load_factories
Gko::Testing.load_cucumber_support
Gko::Testing.load_assertions
Gko::Testing.load_helpers

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

ActionController::Base.allow_rescue = false
Cucumber::Rails::World.use_transactional_fixtures = true
Rails.backtrace_cleaner.remove_silencers!

World(GlobalHelpers)
Gko.out = StringIO.new('')

