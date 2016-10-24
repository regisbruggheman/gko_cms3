module Gko
  module ImageBank
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_image_bank

      initializer 'gko.image_bank.require_section_types' do
        config.to_prepare do
          require_dependency 'image_bank'
        end
      end

      initializer "gko.image_bank.register_page_types" do
        Gko::PageTypes.register('image_bank', true)
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::ImageBank)
      end
    end
  end
end