module Gko
  module Blog
    class Engine < ::Rails::Engine
      include Gko::Engine
      
      engine_name :gko_blog
      
      initializer 'gko.blog.require_section_types' do
        config.to_prepare { require_dependency 'blog' }
      end

      initializer "gko.blog.register_page_types" do
        Gko::PageTypes.register('blog', true)
      end
      
      initializer 'gko.blog.configure_routing_filters' do
        RoutingFilter::SectionRoot.anchors << '\d{4}'
      end

      config.after_initialize do
        Gko.register_engine(Gko::Blog)
      end
    end
  end
end

