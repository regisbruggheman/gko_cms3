# RVM bootstrap
#$:.unshift(File.expand_path("~/.rvm/lib"))
#require 'rvm/capistrano'
#set :rvm_ruby_string, '1.9.2-p0'
#set :rvm_type, :user


# bundler bootstrap
require 'bundler/capistrano'

##########################################
# capistrano
##########################################

# main details
set :hostname, '174.120.222.66' # account ip or domain
role :web, hostname
role :app, hostname
role :db, hostname, :primary => true

# server details
set :deploy_dir, 'ror' #deploy directory
set :domain, 'joufdesignhost.com' # hosting server name
set :keep_releases, 2
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :group_writable, false
set :deploy_via, :remote_cache

set :password, "#SITE5_ACCOUNT_PASSWORD" # account password
set :user, '#SITE5_ACCOUNT_USERNAME' # account username
set :dbpassword, '#SITE5_DATABASE_PASSWORD' # account database user password
set :dbuser, '#SITE5_DATABASE_USERNAME' # account database username

# repo details
set :scm, 'git'
#set :scm_username, "jdfdesign"
#set :scm_account, 'jdfdesign'
set :repository, "git@github.com:jdfdesign/#GIT_PROJECT_NAME.git" #Github repository
set :scm_passphrase, "#SITE5_ACCOUNT_PASSWORD"
set :git_enable_submodules, 1 # if you have vendored rails
set :scm_verbose, true

#set :stages, %w(staging production)
#set :default_stage, "staging"
set :branch, 'master'
set :stage, 'production'
#set :branch, Proc.new {
#case stage
#when 'staging': 'master'
#when 'production': 'master'
#end
# 'master'
#}

# deploy config
set :deploy_to, "/home/#{user}/#{deploy_dir}"

# additional settings
#ssh_options[:keys] = %w(/home/user/.ssh/id_rsa)            # If you are using ssh_keysset :chmod755, "app config db lib public vendor script script/* public/disp*"set :use_sudo, false
set :copy_exclude, [".gitignore", ".git", ".cache", ".DS_Store", "config/deploy.rb", "Capfile", "config/deploy"]

################################
set :application, "#{stage}"
set :rails_env, "#{stage}"
set :deploy_to, "/#{deploy_to}/#{stage}"
#######################################################
after 'deploy:setup' do
  deploy.setup_shared_folder
  deploy.setup_database
end
after "deploy:update_code" do
  deploy.update_symlinks
  deploy.create_htaccess
  dragonfly.symlink
end
after "deploy:symlink" do
  #deploy.update_subdomains_symlink
  #deploy.update_crontab
end
#######################################################
#######################################################
# namespace :deploy
#######################################################
#######################################################
namespace :deploy do

  desc "Create default shared directories in shared_path"
  task :setup_shared_folder, :roles => :app do
    # the -p flag on mkdir makes intermediate directories (i.e. both /bin and /bin/history),
    # and doesn't raise an error if any of the directories already exist.
    dirs = %w(config system).map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end

  desc "Création du fichier de configuration database.yml"
  task :setup_database do
    puts "\033[1;41m Création du fichier de configuration database.yml \033[0m"
    db_config = <<-EOF
    settings:  &settings
      adapter: mysql2
      encoding: utf8
      username: #{dbuser}
      password: #{dbpassword}
      database: #{user}_#{stage}
      reconnect: true
      pool: 5
      host: 127.0.0.1
      
    #{rails_env}:
      <<: *settings
    
    # needed else app could not start properly  
    development:
      <<: *settings
    EOF
    put db_config, "#{shared_path}/config/database.yml"
  end

  task :update_symlinks, :except => {:no_release => true}, :roles => :app do
    # -f argument replace the existing symlink automatically
    # -n argument replace the existing directory symlink automatically
    # If the existing symlink you're trying to replace points to a directory, 
    # the above actually creates a symlink inside the dereferenced directory 
    # the old symlink points to. (Or fails if the referent is invalid.)
    # Symlink the database configuration file

    #add staging symlink if stage is production

    run "ln -nsf #{shared_path}/config/database.yml #{release_path}/config/database.yml"

    #run "rm -rf #{release_path}/public/uploads"
    #run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    #run "ln -nsf #{shared_path}/fx #{release_path}/public/fx"
    run "ln -nsf #{shared_path}/system #{release_path}/public/system"

    run "mv /home/#{user}/public_html /home/#{user}/public_html.moved"

    run "ln -nsf #{release_path}/public /home/#{user}/public_html"

    run "chmod 755 #{release_path}/public"
  end

  desc <<-DESC
    Création du fichier htaccess pour Site5
  DESC
  task :create_htaccess do
    puts "\033[1;41m Création du fichier htaccess \033[0m"
    htaccess = <<-EOF
PassengerEnabled on
PassengerAppRoot /home/#{user}/ror/#{stage}/current
      RailsEnv #{rails_env}
    EOF

    put htaccess, "#{current_release}/public/.htaccess"
  end


  #desc <<-DESC
  #  Copie du dernier fichier htaccess
  #DESC
  #task :copy_htaccess, :except => { :no_release => true }, :roles => :app do
  #  puts "\033[1;41m Copie du dernier fichier htaccess \033[0m"
  #  is_htaccess_exist = capture("if [ -e #{previous_release}/public/.htaccess ]; then echo 'true'; else echo 'no'; fi").strip
  #  if is_htaccess_exist == 'true'
  #    run "if [ -e #{previous_release}/public/.htaccess ]; then cp #{previous_release}/public/.htaccess #{current_release}/public/.htaccess; fi"
  #  else
  #    deploy.create_htaccess
  #  end
  #end

  desc <<-DESC
    Restarts your application. \
    Overwrites default :restart task for Passenger server.
  DESC
  task :restart, :roles => :app, :except => {:no_release => true} do
    puts "\033[1;41m Restart passenger \033[0m"
    passenger.restart
  end

  desc <<-DESC
    Starts the application servers. \
    Overwrites default :start task for Passenger server.
  DESC
  task :start, :roles => :app do
    puts "\033[1;41m Start passenger \033[0m"
    passenger.start
  end

  desc <<-DESC
    Stops the application servers. \
    Overwrites default :start task for Passenger server.
  DESC
  task :stop, :roles => :app do
    puts "\033[1;41m Stop passenger \033[0m"
    passenger.stop
  end
end

#####################################
# namespace :dragonfly
#####################################
namespace :dragonfly do
  desc "Symlink the Rack::Cache files"
  task :symlink, :roles => [:app] do
    run "mkdir -p #{shared_path}/tmp/dragonfly && ln -nfs #{shared_path}/tmp/dragonfly #{release_path}/tmp/dragonfly"
  end
end
#####################################
# namespace :passenger
#####################################
namespace :passenger do
  desc <<-DESC
    Restarts your application. \
    This works by creating an empty `restart.txt` file in the `tmp` folder
    as requested by Passenger server.
  DESC
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc <<-DESC
    Starts the application servers. \
    Please note that this task is not supported by Passenger server.
  DESC
  task :start, :roles => :app do
    logger.info ":start task not supported by Passenger server"
  end

  desc <<-DESC
    Stops the application servers. \
    Please note that this task is not supported by Passenger server.
  DESC
  task :stop, :roles => :app do
    logger.info ":stop task not supported by Passenger server"
  end
end
