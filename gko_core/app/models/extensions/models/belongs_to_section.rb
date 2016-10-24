require 'active_support/concern'

module Extensions
  module Models
    module BelongsToSection
      
      extend ActiveSupport::Concern
      
      included do
        
        belongs_to_site
        class_attribute :sortable
        self.sortable = false
        belongs_to :section, :touch => true
        validates :section_id, :presence => true
        attr_accessible :section, :section_id

        before_validation do |r|
          r.site = r.section.site if r.section.presence
        end

      end

      module ClassMethods

        def previous(record, field = "title")
          with_section(record.section_id).where("#{field} < ?", record.send(field)).order("#{field} DESC")
        end

        def next(record, field = "title")
          with_section(record.section_id).where("#{field} > ?", record.send(field)).order("#{field} ASC")
        end
        
        def with_section(section_id)
          where("#{self.table_name}.section_id = ?", section_id)
        end
      end

    end # BelongsToSection
  end # Models
end # Extensions