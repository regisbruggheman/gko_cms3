# encoding: utf-8
module Gko
  module Themes
    module ActionController

      extend ActiveSupport::Concern

      included do
        include Gko::Themes::CommonMethods
        helper_method :current_theme_stylesheet_path,
                      :current_theme_javascript_path,
                      :current_theme_image_path
      end

      module ClassMethods
        def has_theme
          before_filter do |controller|
            controller.install_theme
          end
          #after_filter  do |controller|
          #  controller.uninstall_theme
          #end
        end
      end

      def install_theme
        return if !valid_theme?
        
        self.view_paths.insert 0, ::ActionView::FileSystemResolver.new(theme_view_path_for(theme_name))
        #self.view_paths.each do |p|
        #  Rails.logger.info("THEME " + p.to_s)
        #end
      end

      def uninstall_theme

      end

      def current_theme_stylesheet_path(asset)
        base_theme_stylesheet_path(:theme => self.theme_name, :asset => "#{asset}.css")
      end

      def current_theme_javascript_path(asset)
        base_theme_javascript_path(:theme => self.theme_name, :asset => "#{asset}.js")
      end

      def current_theme_image_path(asset)
        image, extension = asset.split(".")
        base_theme_image_path(:theme => self.theme_name, :asset => "#{image}.#{extension}")
      end
    end
  end
end

