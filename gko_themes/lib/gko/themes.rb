require 'zip/zip'
require 'zip/zipfilesystem'
require 'active_support/dependencies'
module Gko
  module Themes
    require 'gko/themes/engine'
    require 'gko/themes/interpolation'
    require 'gko/themes/config'
    require 'gko/themes/common_methods'
    require 'gko/themes/views_helper'
    require 'gko/themes/action_view'
    require 'gko/themes/assets_controller'
    require 'gko/themes/action_controller'
    require 'gko/themes/action_mailer'
    require 'gko/themes/railtie'
    #require 'gko/themes/sass_helper'

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def config
        @config ||= Gko::Themes::Config.new
        yield(@config) if block_given?
        @config
      end

      def available_themes(&block)
        Dir.glob(File.join(config.themes_path, "*"), &block)
      end

      alias each_theme_dir available_themes

      def available_theme_names
        available_themes.map { |theme| File.basename(theme) }
      end
      def add_themes_path_to_sass
        Rails.logger.info "add_themes_path_to_sass #{config.sass_is_available?}"
        if config.sass_is_available?
          each_theme_dir do |dir|
            if File.directory?(dir) # Need to get rid of the '.' and '..'

              sass_dir = "#{dir}/stylesheets/sass"
              css_dir = "#{dir}/stylesheets"

              unless already_configured_in_sass?(sass_dir)
                Sass::Plugin.add_template_location sass_dir, css_dir 
              end
            end
          end 
        else
          raise "Sass is not available. What are you trying to do?"
        end
      end

      def already_configured_in_sass?(sass_dir)
        Sass::Plugin.template_location_array.map(&:first).include?(sass_dir)
      end
      def factory_paths
        @factory_paths ||= [root.join("spec/factories").to_s]
      end
    end
  end
end