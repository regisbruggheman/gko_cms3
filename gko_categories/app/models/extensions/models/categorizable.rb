require 'active_support/concern'

module Extensions
  module Models
    module Categorizable

      extend ActiveSupport::Concern

      included do
        has_many :categorizations, :as => :categorizable, :include => :category, :dependent => :destroy
        has_many :categories, :through => :categorizations

        accepts_nested_attributes_for :categorizations, :allow_destroy => true
        attr_accessible :categorizations_attributes, :categories_ids_attributes, :category_ids
      end

      module ClassMethods

        def categorized(category_ids)
          includes(:categorizations).where(:categorizations => {:category_id => category_ids})
        end

        def with_category(category_id)
          includes(:categorizations).where(:categorizations => {:category_id => category_id})
        end

      end #ClassMethods

      def available_categories
        categories.translated
      end

    end # Categorizable
  end # Models
end # Extensions
