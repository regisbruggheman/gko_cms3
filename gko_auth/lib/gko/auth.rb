require 'devise'
require 'cancan'

module Gko
  module Auth
    require 'gko_core'
    require 'gko/controllers/permissions'
    require 'gko/token_resource'
    require 'gko/auth/engine'

    class << self

      def config(&block)
        yield(Gko::Auth::Config)
      end

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [root.join("spec/factories").to_s]
      end
    end
  end
end

