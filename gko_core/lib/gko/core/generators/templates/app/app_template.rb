app_folder = "gko_core/lib/gko/generators/templates/app"
puts "source #{config[:source]}"
copy_file config[:source].join("#{app_folder}/Gemfile"), "#{app_path}/Gemfile"
copy_file config[:source].join("#{app_folder}/seeds.rb"), "#{app_path}/db/seeds.rb"
copy_file config[:source].join("#{app_folder}/initializers/locale.rb"), "#{app_path}/config/initializers/locale.rb"
copy_file config[:source].join("#{app_folder}/views/layouts/public.html.rb"), "#{app_path}/app/views/layouts/public.html.rb"
copy_file config[:source].join("#{app_folder}/public.css"), "#{app_path}/public/stylesheets/public.css"
copy_file config[:source].join("#{app_folder}/capistrano/Capfile"), "#{app_path}/Capfile"
copy_file config[:source].join("#{app_folder}/capistrano/deploy.rb"), "#{app_path}/config/deploy.rb"
remove_file 'public/index.html'

