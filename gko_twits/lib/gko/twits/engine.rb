module Gko
  module Twits
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_twits

      initializer 'gko.twits.require_section_types' do
        config.to_prepare do
          require_dependency 'twit_list'
        end
      end

      initializer "gko.twits.register_page_types" do
        Gko::PageTypes.register('twit_list', true)
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Twits)
      end
    end
  end
end