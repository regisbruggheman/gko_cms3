require 'rake'
require 'active_record'
require 'custom_fixtures'

namespace :db do
  namespace :sites do
    desc "Create a site"
    task :create => :environment do
      require File.join(File.dirname(__FILE__), '..', '..', 'db', 'default', 'base.rb')
      require File.join(File.dirname(__FILE__), '..', '..', 'db', 'default', 'sites.rb')
    end

  end
end