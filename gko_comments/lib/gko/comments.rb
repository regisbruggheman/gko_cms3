module Gko
  module Comments
    require 'gko/active_record/commentable'
    require 'gko/comments/engine'
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





 
