require 'createsend'

module Gko
  module Newsletters
    require 'gko/newsletters/campaign_monitor_subscriber'
    require 'gko/newsletters/engine'
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