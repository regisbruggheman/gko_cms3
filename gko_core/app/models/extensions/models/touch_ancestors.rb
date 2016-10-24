# nested_set gem do not touch parent so we simulate it here

require 'active_support/concern'

module Extensions
  module Models
    module TouchAncestors
      
      extend ActiveSupport::Concern
      
      included do
        
        after_save :touch_ancestors, :if => proc { |m| m.child? }
        before_destroy :touch_ancestors, :if => proc { |m| m.child? }

      end

      module ClassMethods

      end

      def touch(name = nil)
        super(name)
        touch_ancestors if self.child?
      end
  
      protected

      # Touch each ancestor to update Rails cache
      def touch_ancestors
        parent.touch if parent
      end
      
    end # TouchAncestors
  end # Models
end # Extensions