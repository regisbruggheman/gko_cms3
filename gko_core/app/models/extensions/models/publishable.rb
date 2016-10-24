require 'active_support/concern'

module Extensions
  module Models
    module Publishable
      
      extend ActiveSupport::Concern

      included do
        
        ## virtual attributes ##
        attr_accessor :draft

        ## white_list ##
        attr_accessible :draft, :published_at
        
        ## validations ##
        before_validation do |r|
          if draft == "1"
            r.published_at = nil
          elsif r.published_at.nil?
            r.published_at = Time.zone.now
          end
        end

      end
      
      module ClassMethods

        def published(date = Time.zone.now)
          where("#{table_name}.published_at IS NOT NULL AND #{table_name}.published_at < ?", date)
        end
        alias_method :availables, :published

        def unpublished(date = Time.zone.now)
          where("#{table_name}.published_at IS NULL OR #{table_name}.published_at > ?", date)
        end

        def published_between(start_date, end_date)
          where("#{table_name}.published_at IS NOT NULL AND #{table_name}.published_at >= ? AND #{table_name}.published_at <= ?", start_date, end_date)
        end

        def by_month(date)
          where(:published_at => date.beginning_of_month..date.end_of_month).with_globalize
        end

        def by_year(date)
          where(:published_at => date.beginning_of_year..date.end_of_year).with_globalize
        end
    
        def by_archive(archive_date)
          where(["#{table_name}.published_at between ? and ?", archive_date.beginning_of_month, archive_date.end_of_month])
        end

        def published_dates_older_than(date)
          published(date).pluck(:published_at)
        end
    
        def recent(count = 4)
          published.limit(count).with_globalize
        end

        def live(conditions = {})
          published.with_globalize(conditions)
        end

      end # !ClassMethods

      def draft?
        self.published_at.blank?
      end

      def published?
        !self.draft? and self.published_at <= Time.zone.now
      end
        
    end # Publishable
  end # Models
end # Extensions
