# Most part of this code is taken from Gko 2012.03.29

require 'rake'
require 'active_record'
require 'custom_fixtures'


namespace :db do
  desc %q{Loads a specified fixture file:
  For .yml/.csv use rake db:load_file[gko/filename.yml,/absolute/path/to/parent/]
  For .rb       use rake db:load_file[/absolute/path/to/sample/filename.rb]}

  task :load_file, [:file, :dir] => :environment do |t, args|
    file = Pathname.new(args.file)
    puts "trying loading #{file}"
    if %w{.csv .yml}.include? file.extname
      puts "loading fixture #{Pathname.new(args.dir).join(file)}"
      Gko::Core::Fixtures.create_fixtures(args.dir, file.to_s.sub(file.extname, ""))
    elsif file.exist?
      puts "loading ruby #{file}"
      require file
    end
  end

  desc "Loads fixtures from the the dir you specify using rake db:load_dir[loadfrom]"
  task :load_dir, [:dir] => :environment do |t, args|
    dir = args.dir
    dir = File.join(Rails.root, "db", dir) if Pathname.new(dir).relative?

    fixtures = ActiveSupport::OrderedHash.new
    ruby_files = ActiveSupport::OrderedHash.new
    Dir.glob(File.join(dir, '**/*.{yml,csv,rb}')).each do |fixture_file|
      ext = File.extname fixture_file
      if ext == ".rb"
        ruby_files[File.basename(fixture_file, '.*')] = fixture_file
      else
        fixtures[fixture_file.sub(dir, "")[1..-1]] = fixture_file
      end
    end
    fixtures.sort.each do |relative_path, fixture_file|
      # an invoke will only execute the task once
      Rake::Task["db:load_file"].execute(Rake::TaskArguments.new([:file, :dir], [relative_path, dir]))
    end
    ruby_files.sort.each do |fixture, ruby_file|
      # an invoke will only execute the task once
      Rake::Task["db:load_file"].execute(Rake::TaskArguments.new([:file], [ruby_file]))
    end
  end

  desc "Migrate schema to version 0 and back up again. WARNING: Destroys all data in tables!!"
  task :remigrate => :environment do
    require 'highline/import'
    if ENV['SKIP_NAG'] or ENV['OVERWRITE'].to_s.downcase == 'true' or agree("This task will destroy any data in the database. Are you sure you want to \ncontinue? [y/n] ")

      # Drop all tables
      ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }

      # Migrate upward
      Rake::Task["db:migrate"].invoke

      # Dump the schema
      Rake::Task["db:schema:dump"].invoke
    else
      say "Task cancelled."
      exit
    end
  end

  desc "Loads sample data"
  task :load_sample, [:engine_name]  => :environment  do |t, args|
    t0 = Time.now
    puts "== Load: example ====================================================="
    if(args[:engine_name])
      
    else
      require File.join(File.dirname(__FILE__), '..', '..', 'db', 'default', 'base.rb')
      @engine_paths ||= Rails::Application::Railties.engines.collect { |engine| engine.config.root.to_s }
      @engine_paths.each do |path|
        sample_path = File.join(path, 'db', 'sample')
        Rake::Task['db:load_dir'].reenable
        Rake::Task["db:load_dir"].invoke(sample_path)
      end
    end
    puts "== Load: example (%0.4fs) ============================================\n" % (Time.now - t0)
  end

  desc "Loads default data"
  task :load_default => :environment do
    t0 = Time.now
    puts "== Load: default ====================================================="
    # Rake::Task['db:seed'].invoke rescue nil
    @engine_paths ||= Rails::Application::Railties.engines.collect { |engine| engine.config.root.to_s }
    @engine_paths.each do |path|
      puts "#{path}"
      default_path = File.join(path, 'db', 'default')
      Rake::Task['db:load_dir'].reenable
      Rake::Task["db:load_dir"].invoke(default_path)
    end

    # Need to rebuild it after import
    Section.rebuild!

    puts "== Load: default (%0.4fs) ============================================\n" % (Time.now - t0)
  end

  desc "Bootstrap is: migrating, loading defaults, sample data and seeding (for all extensions) invoking create_admin and load_products tasks"
  task :bootstrap do
    require 'highline/import'

    # remigrate unless production mode (as saftey check)
    if %w[demo development test].include? Rails.env
      if ENV['AUTO_ACCEPT'] or agree("This task will destroy any data in the database. Are you sure you want to \ncontinue? [y/n] ")
        ENV['SKIP_NAG'] = 'yes'
        Rake::Task['db:drop'].invoke rescue nil
        Rake::Task["db:create"].invoke
        Rake::Task["db:remigrate"].invoke
      else
        say "Task cancelled, exiting."
        exit
      end
    else
      say "NOTE: Bootstrap in production mode will not drop database before migration"
      Rake::Task["db:migrate"].invoke
    end

    ActiveRecord::Base.send(:subclasses).each do |model|
      model.reset_column_information
    end

    load_defaults = Site.count == 0
    unless load_defaults # ask if there are already Site => default data hass been loaded
      load_defaults = agree('Site present, load sample data anyways? [y/n]: ')
    end
    if load_defaults
      Rake::Task["db:sites:create"].invoke
      Rake::Task["db:master:create"].invoke
      Rake::Task["db:load_default"].invoke
    end

    if Rails.env.production?
      load_sample = agree("WARNING: In Production and pages exist in database, load sample data anyways? [y/n]:")
    else
      load_sample = true if ENV['AUTO_ACCEPT']
      load_sample = agree('Load Sample Data? [y/n]: ') unless load_sample
    end

    if load_sample
      #prevent errors for missing attributes (since rails 3.1 upgrade)
      Rake::Task["db:load_sample"].invoke
      Rake::Task["db:seed"].invoke
    end

    puts "Bootstrap Complete.\n\n"
  end

  task :populate_image_bank => :environment do
    puts "creating images"
    @site = Site.first
    @image_bank = @site.image_banks.first
    unless @image_bank
      @image_bank = ImageBank.create(:title => "Image Bank", :site => @site)
    end
    @user = User.first
    @account = Account.first
    @files = Dir["#{Rails.root}/public/original/*.jpg"]
    @files.each do |file|
      puts "creating image ... #{file}"
      @image_bank.image_bank_photos.create!(:source => File.open(file))
    end
  end


  task :unmigrate_page_content => :environment do
    Site.all.each do |site|
      puts "============\n#{site.title}"
      site.languages.each do |language|
        puts "============\n#{language.code}"
        site.pages.with_translations(language.code.to_sym).each do |page|
          page.content.destroy
        end
      end
    end
  end
  
  task :migrate_page_content => :environment do
    Site.all.each do |site|
      puts "============\n#{site.title}"
      site.languages.each do |language|
        puts "============\n#{language.code}"
        site.pages.with_translations(language.code.to_sym).each do |page|
          page.build_default_content
          page.save!
            #content = page.build_default_content
            #content.body = page.body
            #content.title = page.title
            #content.section_id = page.id
            #if page.save!
            #  puts "============OK"
            #else
            #  page.errors.each do |k, v|
            #    puts "============\n#{k[v]}"
           #   end
           # end
        end
      end
    end
  end
  # clean up code produce by wymeditor
  task :delete_all_images => :environment do
    Site.all.each do |site|
      puts "============\n#{site.title}"
      site.images.each do |img|
        img.destroy
      end
    end
  end
  
  # clean up code produce by wymeditor
  task :update_html_images_path => :environment do
    Site.all.each do |site|
      puts "============\n#{site.title}"
      site.languages.each do |language|
        puts "============\n#{language.code}"
        Section.with_translations(language.code.to_sym).each do |section|
          if section.body.present?
            doc = Nokogiri::HTML(section.body)
            all_tags = doc.xpath("//img")
            all_tags.each do | img_tag |
              image_name = img_tag['src'].split('/').last.split('?').first
              #puts image_name
              if image = Image.find_by_image_name(image_name)
                img_tag['src'] = image.thumbnail(:medium).url().to_s
                img_tag['title'] = image.image_name.to_s
                img_tag['alt'] = image.image_name.to_s
                img_tag['data-id'] = image.id.to_s
                img_tag['data-url'] = image.thumbnail(:large).url().to_s
              end
              #puts img_tag.to_s
            end
            #puts doc.css("body").inner_html
            section.body = doc.css("body").inner_html
            section.save
            #puts doc
          end
        end
      end
    end
  end
end

namespace :gko do
  namespace :db do
    desc "Back up the database"
    task :backup do
      sh "backup perform --trigger db_backup --config_file config/backup.rb --data-path db --log-path log --tmp-path tmp"
    end
  end
  task :upgrade => :environment do
    Rake::Task['gko:install'].invoke rescue nil
    Rake::Task['db:migrate'].invoke rescue nil
    Rake::Task['gko:permissions'].invoke rescue nil
    # Rake::Task['gko:normalize_paths'].invoke rescue nil
    Site.all.each do |site|
      site.plugins = Gko.engine_names.map { |n| n.to_s }
      site.save!
    end
  end

  task :update_rental_rates => :environment do
    RentalProperty.all.each do |property|
      property.update_max_min_rates
    end
  end


  task :normalize_paths => :environment do
    Site.all.each do |site|
      puts "#{site}"
      locales = []
      locales << I18n.default_locale.to_sym
      locales << site.locales.split(",").map(&:to_sym) if (site.locales.present?)
      locales.flatten.compact.uniq
      locales.each do |locale|
        puts "#{locale}"
        Globalize.locale = locale.to_s
        site.sections.each do |section|
          puts "#{section.title}"
          if section.parent_id.present?
            section.update_path
          else
            section.slug = section.path = ""
          end
          puts "path #{section.path}"
          section.translations.find_by_locale(locale.to_s).update_attribute(:path, section.path)
        end
      end
    end
  end

end
