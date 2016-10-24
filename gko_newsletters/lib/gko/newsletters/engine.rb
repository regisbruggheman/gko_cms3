module Gko
  module Newsletters
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_newsletters

      initializer 'gko.newsletters.require_section_types' do
        config.to_prepare do
          require_dependency 'newsletter_list'
        end
      end

      initializer "gko.newsletters.register_page_types" do
        Gko::PageTypes.register('newsletter_list', true)
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Newsletters)
      end
    end
  end
end
