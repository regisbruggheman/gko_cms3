module Gko
  module Portfolio
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_portfolio

      initializer 'gko.portfolio.require_section_types' do
        config.to_prepare { require_dependency 'portfolio' }
      end

      initializer "gko.portfolio.register_page_types" do
        Gko::PageTypes.register('portfolio', true)
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Portfolio)
      end
    end
  end
end