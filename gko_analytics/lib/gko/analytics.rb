require 'garb'
require 'gchart'
module Gko
  module Analytics
    require 'gko/analytics/visits'
    require 'gko/analytics/pageviews'
    require 'gko/analytics/exits'
    require 'gko/analytics/bounces'
    require 'gko/analytics/visits_by_language'
    require 'gko/analytics/engine'
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
