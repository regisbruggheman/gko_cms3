module Gko
  module Themes
    class Engine < ::Rails::Engine
      include Gko::Engine
      engine_name :gko_themes
      # sets the manifests / assets to be precompiled
      initializer "gko.themes.assets.precompile" do |app|
        app.config.assets.precompile += ['theme_preview.js','theme_preview.css']
      end
      
      initializer "gko.themes.register.plugin" do
        Gko::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'themes'
          plugin.version = %q{2.0.0}
          plugin.menu_match = %r{themes}
          plugin.hide_from_menu = false
          plugin.always_allow_access = true
          plugin.icon = 'tint'
          plugin.url = proc { Rails.application.routes.url_helpers.admin_themes_path() }
        end
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Themes)
      end
    end
  end
end

