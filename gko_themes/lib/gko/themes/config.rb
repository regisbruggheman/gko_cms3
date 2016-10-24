# encoding: utf-8
module Gko
  module Themes
    class Config

      attr_writer :base_dir, :themes_dir, :assets_dir, :views_dir
      attr_accessor :use_sass, :default_theme

      include Interpolation

      def initialize(&block)
        @use_sass = true
        #@default_theme = 'default'
        yield if block_given?
      end

      def base_dir
        @base_dir ||= Rails.root.to_s
      end

      # relative assets dir for view overloading support
      # used for theme_view_path_for method to get theme path and add to view paths.
      # Defaults to themes_dir for non asset pipeline users
      #
      # If you are using the Rails Asset Pipeline, this should be changed to the 
      # path of your assets in your app. For example, if you store your themes
      # under /app/assets/themes - {Rails.root}/app/assets/themes
      # you would need to set this to 'app/assets/themes' in your initializer config
      def assets_dir
        @assets_dir ||= ":root/app/assets/themes/:name"
      end

      # relative views directory for theme views to be separated from assets
      # used for Asset Pipeline support. Defaults to match {assets_dir}/views
      def views_dir
        @views_dir ||= ":root/app/assets/themes/:name/views"
      end

      def themes_dir
        @themes_dir ||= ":root/app/assets/themes"
      end

      # Full path to themes
      def themes_path
        interpolate(themes_dir)
      end

      def clear
        @base_dir = nil
        @themes_dir = nil
        @assets_dir = nil
        @views_dir = nil
      end

      def use_sass?
        @use_sass and sass_is_available?
      end

      def sass_is_available?
        !!defined?Sass::Plugin
      end
    end
  end
end