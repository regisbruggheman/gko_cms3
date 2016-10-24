# encoding: utf-8
module Gko
  module Themes
    module CommonMethods

      include Gko::Themes::Interpolation

      def theme_name
        @theme_name ||= (params[:theme]  || site.theme_name)
      end


      public

      def valid_theme?
        site.has_theme? || params[:theme].presence
      end

      def public_theme_path
        theme_view_path("/")
      end

      def theme_asset_path
        theme_asset_path_for(theme_name)
      end

      def theme_view_path
        theme_view_path_for(theme_name)
      end

      def theme_view_path_for(theme_name)
        interpolate(Gko::Themes.config.views_dir, theme_name)
      end

      def theme_asset_path_for(theme_name)
        interpolate(Gko::Themes.config.assets_dir, theme_name)
      end
    end
  end
end