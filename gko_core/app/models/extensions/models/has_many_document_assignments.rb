require 'active_support/concern'

module Extensions
  module Models
    module HasManyDocumentAssignments

      extend ActiveSupport::Concern

      included do
        has_many :document_assignments,
          :as => :attachable,
          :dependent => :destroy,
          :order => "document_assignments.position"
        has_many :documents,
          :through => :document_assignments

        accepts_nested_attributes_for :document_assignments, :allow_destroy => true
        attr_accessible :document_assignments_attributes, :documents_ids_attributes, :document_ids
      end

      module ClassMethods

      end

    end # HasManyDocumentAssignments
  end # Models
end # Extensions
