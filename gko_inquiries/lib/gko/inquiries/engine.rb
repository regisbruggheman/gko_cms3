module Gko
  module Inquiries
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_inquiries

      initializer "gko.inquiries.register.plugin" do
        Gko::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'inquiries'
          plugin.version = %q{2.0.0}
          plugin.menu_match = %r{inquiries}
          plugin.hide_from_menu = false
          plugin.always_allow_access = true
          plugin.icon = 'envelope'
          plugin.url = proc { Rails.application.routes.url_helpers.admin_site_inquiries_path(Site.current) }
        end
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Inquiries)
      end
    end
  end
end