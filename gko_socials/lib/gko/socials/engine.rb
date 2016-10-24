module Gko
  module Socials
    
    OAUTH_PROVIDERS = [
      ["Facebook", "facebook"],
      ["Twitter", "twitter"],
      ["Google", "google_oauth2"]
    ]
    
    
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_socials
      
      config.after_initialize do
        Gko.register_engine(Gko::Socials)
      end
    end
    
    # Setup all OAuth providers
    def self.init_provider(provider)
      return unless ActiveRecord::Base.connection.table_exists?('authentication_methods')
      key, secret = nil
      AuthenticationMethod.where(:environment => ::Rails.env).each do |auth_method|
        if auth_method.provider == provider
          key = auth_method.api_key
          secret = auth_method.api_secret
          puts("[Gko Social] Loading #{auth_method.provider.capitalize} as authentication source")
        end
      end
      self.setup_key_for(provider.to_sym, key, secret)
    end

    def self.setup_key_for(provider, key, secret)
      Devise.setup do |config|
        config.omniauth provider, key, secret
      end
    end
    
  end
end