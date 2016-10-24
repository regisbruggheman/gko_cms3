module Gko
  module Comments
    class Engine < ::Rails::Engine
      include Gko::Engine
      engine_name :gko_comments

      config.after_initialize do
        Gko.register_engine(Gko::Comments)
      end
    end
  end
end
