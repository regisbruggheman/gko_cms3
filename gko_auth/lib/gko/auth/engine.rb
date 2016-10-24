module Gko
  module Auth
    class Engine < ::Rails::Engine
      include Gko::Engine
      
      engine_name :gko_auth

      config.autoload_paths += %W(#{config.root}/lib)
      ActiveRecord::Base.class_eval { include Gko::TokenResource }

      config.before_configuration do
        require 'gko/auth/devise'
      end

    end
  end
end
