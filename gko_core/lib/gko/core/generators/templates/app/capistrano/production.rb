#############################################################
#	Application
#############################################################
set :application, "#{stage}"
set :rails_env, "#{stage}"
set :deploy_to, "/home/#{user}/#{deploy_dir}/#{stage}"
#############################################################
#	deploy
#############################################################
after 'deploy:setup' do
  deploy.setup_shared_folder
end
after "deploy:update_code" do
  deploy.update_symlinks
  deploy.copy_htaccess
  bundler.bundle_new_release
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
  task :update_subdomains_symlink do
    puts "\033[1;41m update_subdomains_symlink \033[0m"
    #run "if [ -e #{previous_release}/public/previmeteo ]; then cp #{previous_release}/public/previmeteo #{current_release}/public/previmeteo; fi"
    run "ln -nfs /home/#{user}/ror/production/current/public /home/#{user}/public_html"
    run "ln -nfs /home/#{user}/ror/production/current/public /home/#{user}/public_html/fr"
    run "ln -nfs /home/#{user}/ror/staging/current/public /home/#{user}/public_html/staging"
  end
end
