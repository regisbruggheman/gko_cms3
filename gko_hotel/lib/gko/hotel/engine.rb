module Gko
  module Hotel
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_hotel

      config.after_initialize do
        Gko.register_engine(Gko::Hotel)
      end
    end
  end
end