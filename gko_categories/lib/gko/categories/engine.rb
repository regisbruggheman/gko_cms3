module Gko
  module Categories
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_categories

      initializer 'gko.categories.configure_routing_filters' do
        RoutingFilter::SectionRoot.anchors << 'categories'
      end

      config.after_initialize do
        Gko.register_engine(Gko::Categories)
      end

    end
  end
end
