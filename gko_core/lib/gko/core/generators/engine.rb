require 'rails/generators'

module Gko
  module Generators
    class Engine < Rails::Generators::Base
      source_root File.expand_path('../templates/engine', __FILE__)

      attr_reader :name

      def initialize(name, options = {})
        puts "Initializing engine #{name} ..."
        @name = name
        super()
      end

      def build
        empty_directory "gko-#{name}"
        template "gemspec.erb", "gko-#{name}/gko-#{name}.gemspec"
        template 'Gemfile.erb', "gko-#{name}/Gemfile"

        empty_directory "gko-#{name}/app"
        empty_directory "gko-#{name}/app/controllers"
        empty_directory "gko-#{name}/app/models"
        empty_directory "gko-#{name}/app/views"

        empty_directory "gko-#{name}/config"
        empty_directory "gko-#{name}/config/locales"
        template 'en.yml.erb', "gko-#{name}/config/locales/en.yml"
        template 'fr.yml.erb', "gko-#{name}/config/locales/fr.yml"
        template 'redirects.rb.erb', "gko-#{name}/config/redirects.rb"
        template 'routes.rb.erb', "gko-#{name}/config/routes.rb"

        empty_directory "gko-#{name}/db/migrate"
        template 'migration.rb.erb', "gko-#{name}/db/migrate/#{migration_timestamp}_gko_#{name}_create_tables.rb"

        empty_directory "gko-#{name}/features"
        template 'env.rb', "gko-#{name}/features/env.rb"
        template 'feature.erb', "gko-#{name}/features/#{name}.feature"

        empty_directory "gko-#{name}/lib/gko"
        create_file "gko-#{name}/lib/gko-#{name}.rb", "require 'gko/#{name}'"
        template 'engine.rb.erb', "gko-#{name}/lib/gko/#{name}.rb"

        empty_directory "gko-#{name}/lib/testing"
        create_file "gko-#{name}/lib/paths.rb", "gko-#{name}/lib/step_definitions.rb"
        template 'paths.rb.erb', "gko-#{name}/lib/testing/paths.rb"

        empty_directory "gko-#{name}/test"
        template 'all.rb', "gko-#{name}/test/all.rb"
        template 'test_helper.rb.erb', "gko-#{name}/test/test_helper.rb"
      end

      protected

      def migration_timestamp
        Time.now.strftime('%Y%m%d%H%M%S')
      end

      def table_name
        name.tableize
      end

      def class_name
        name.camelize
      end
    end
  end
end
