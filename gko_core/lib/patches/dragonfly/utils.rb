# Fix local path when in development
# Solution provided @https://github.com/markevans/dragonfly/issues/83 does not work
# Shoud be in Gko.config
require 'gem-patching'
require 'dragonfly'
Gem.patching('dragonfly', '0.9.15') do
  if Rails.env.development?
    module Dragonfly
      module ImageMagick
        module Utils
          include Configurable
          configurable_attr :convert_command, "/usr/local/bin/convert" # defaults to "convert"
          configurable_attr :identify_command, "/usr/local/bin/identify" # defaults to "identify"
        end
      end
    end
  end
end     