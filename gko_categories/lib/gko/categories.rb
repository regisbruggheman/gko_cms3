require 'routing_filter'

module Gko
  module Categories
    require 'gko_core'
    require 'gko/categories/routing_filters/categories'
    require 'gko/categories/engine'
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





 

