module Gko
  module Features
    class Engine < ::Rails::Engine
      include Gko::Engine
      engine_name :gko_features
      
      initializer "gko.features.register.plugin" do
        Gko::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'features'
          plugin.version = %q{2.0.0}
          plugin.menu_match = %r{gko/features(s_dialog)?s$}
          plugin.hide_from_menu = false
          plugin.always_allow_access = true
          plugin.icon = 'bell'
          plugin.url = proc { Rails.application.routes.url_helpers.admin_site_features_path(Site.current) }
        end
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Features)
      end
    end
  end
end