module Gko
  module Analytics
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_analytics

      config.after_initialize do
        Gko.register_engine(Gko::Analytics)
      end
    end
  end
end