Gko::Socials::OAUTH_PROVIDERS.each do |provider|
  Gko::Socials.init_provider(provider[1])
end

OmniAuth.config.logger = Logger.new(STDOUT)
OmniAuth.logger.progname = "omniauth"