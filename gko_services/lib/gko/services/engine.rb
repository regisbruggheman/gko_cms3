module Gko
  module Services
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_services

      initializer 'gko.services.require_section_types' do
        config.to_prepare { require_dependency 'service_list' }
      end

      initializer "gko.services.register_page_types" do
        Gko::PageTypes.register('service_list', true)
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Services)
      end
    end
  end
end