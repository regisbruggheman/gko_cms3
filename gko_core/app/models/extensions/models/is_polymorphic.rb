require 'active_support/concern'

module Extensions
  module Models
    module IsPolymorphic
      
      extend ActiveSupport::Concern
      
      included do
        mattr_accessor :types
        self.types = []
      end
      
      module ClassMethods

        def inherited(child)
          types << child.name
          super
        end

        def type_names
          @type_names ||= types.map(&:underscore)
        end

      end #ClassMethods

    end # IsPolymorphic
  end # Models
end # Extensions
