require 'active_support/concern'

module Extensions
  module Models
    module HasManyImageAssignments
      
      extend ActiveSupport::Concern
      
      included do
        has_many :image_assignments,
                 :as => :attachable,
                 :dependent => :destroy,
                 :order => "image_assignments.position"
        has_many :images,
                 :through => :image_assignments
      end

      module ClassMethods

      end
      
      def thumbnail
        image_assignments.first.try(:image)
      end
    end # HasManyImages
  end # Models
end # Extensions