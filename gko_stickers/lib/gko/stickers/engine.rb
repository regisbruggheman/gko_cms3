module Gko
  module Stickers
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_stickers

      initializer 'gko-sticker.configure_routing_filters' do
        RoutingFilter::SectionRoot.anchors << 'tags'
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Stickers)
      end
    end
  end
end
