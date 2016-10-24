require 'active_support/concern'

module Extensions
  module Models
    module BelongsToSite
      
      extend ActiveSupport::Concern
      
      # Whatever is inside of the included block will get executed 
      # in the class context of the class where the module is included.
      included do

      end
      
      module ClassMethods
        
        def belongs_to_site(options = {})
          counter_cache = options.key?(:counter_cache) ? options[:counter_cache] : false
          touch = options.key?(:touch) ? options[:touch] : false
          belongs_to :site, :counter_cache => counter_cache, :touch => touch
          validates :site_id, :presence => true
          attr_accessible :site, :site_id
        end
             
        def in_site(site_id)
          where("#{self.table_name}.site_id = ?", site_id)
        end
      end#ClassMethods

    end #BelongsToSite
  end #Models
end #Extensions
ActiveRecord::Base.send :include, Extensions::Models::BelongsToSite