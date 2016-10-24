namespace :db do
  namespace :master do
    desc "Create admin username and password"
    task :create => :environment do
      require File.join(File.dirname(__FILE__), '..', '..', 'db', 'default', 'users.rb')
    end
  end
end