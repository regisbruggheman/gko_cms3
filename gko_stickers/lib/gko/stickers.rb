module Gko
  module Stickers
    require 'gko_core'
    require 'gko/stickers/routing_filters/stickers'
    require 'gko/stickers/engine'
    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [root.join("spec/factories").to_s]
      end
    end
  end
end
