# NOT USED FOR NOW
# TODO :: FINISH IT @see achemycms

# This recipe contains Capistrano recipes for handling the uploads, ferret index and picture cache files while deploying your application.
# It also contains a ferret:rebuild_index task to rebuild the index after deploying your application.
Capistrano::Configuration.instance(:must_exist).load do

  after "deploy:setup", "gko:shared_folders:create"
  after "deploy:finalize_update", "gko:shared_folders:symlink"
  before "deploy:start", "gko:db:seed"

  namespace :gko do

    namespace :shared_folders do

      # This task creates the shared folders for uploads and config while setting up your server.
      # Call after deploy:setup like +after "deploy:setup", "gko:create_shared_folders"+ in your +deploy.rb+.
      desc "Creates the config and system cache directory in the shared folder. Call after deploy:setup"
      task :create, :roles => :app do
        run "mkdir -p #{shared_path}/config"
        run "mkdir -p #{shared_path}/system"
        # THE OLD PROCESS ::
        # the -p flag on mkdir makes intermediate directories (i.e. both /bin and /bin/history), 
        # and doesn't raise an error if any of the directories already exist.
        # dirs = %w(config system).map { |d| File.join(shared_path, d) }
        # run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
      end

      # This task sets the symlinks for uploads, picture cache and ferret index folder.
      # Call after deploy:symlink like +after "deploy:symlink", "alchemy:symlink_folders"+ in your +deploy.rb+.
      desc "Sets the symlinks for uploads, picture cache and ferret index folder. Call after deploy:symlink"
      task :symlink, :roles => :app do
        run "rm -rf #{release_path}/uploads"
        run "ln -nfs #{shared_path}/uploads #{release_path}/"
        run "ln -nfs #{shared_path}/cache/* #{release_path}/public/"
        run "rm -rf #{release_path}/index"
        run "ln -nfs #{shared_path}/index #{release_path}/"
      end

    end

    desc "Upgrades production database to current Alchemy CMS version"
    task :upgrade do
      run "cd #{current_path} && RAILS_ENV=#{fetch(:rails_env, 'production')} #{rake} alchemy:upgrade"
    end

    namespace :database_yml do

      desc "Creates the database.yml file"
      task :create do
        db_adapter       = Capistrano::CLI.ui.ask("Please enter database adapter (Options: mysql2, or postgresql. Default mysql2): ")
        db_adapter       = db_adapter.empty? ? 'mysql2' : db_adapter.gsub(/^mysql$/, 'mysql2')
        db_name          = Capistrano::CLI.ui.ask("Please enter database name: ")
        db_username      = Capistrano::CLI.ui.ask("Please enter database username: ")
        db_password      = Capistrano::CLI.ui.ask("Please enter database password: ")
        default_db_host  = db_adapter == 'mysql2' ? 'localhost' : '127.0.0.1'
        db_host          = Capistrano::CLI.ui.ask("Please enter database host (Default: #{default_db_host}): ")
        db_host          = db_host.empty? ? default_db_host : db_host
        db_config        = ERB.new <<-EOF
production:
  adapter: #{ db_adapter }
  encoding: utf8
  reconnect: false
  pool: 5
  database: #{ db_name }
  username: #{ db_username }
  password: #{ db_password }
  host: #{ db_host }
EOF
        run "mkdir -p #{shared_path}/config"
        put db_config.result, "#{shared_path}/config/database.yml"
      end

      desc "[internal] Symlinks the database.yml file from shared folder into config folder"
      task :symlink, :except => {:no_release => true} do
        run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      end

    end

    namespace :db do

      desc "Seeds the database with essential data."
      task :seed, :roles => :app do
        run "cd #{current_path} && RAILS_ENV=#{fetch(:rails_env, 'production')} #{rake} gko:db:seed"
      end

    end

  end

  namespace :dragonfly do
    
    desc "Symlink the Rack::Cache files"
    task :symlink, :roles => [:app] do
      run "mkdir -p #{shared_path}/tmp/dragonfly && ln -nfs #{shared_path}/tmp/dragonfly #{release_path}/tmp/dragonfly"
    end
    
  end

end
