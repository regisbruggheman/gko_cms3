require 'active_support/concern'

module Extensions
  module Models
    module CvsExport
      
      extend ActiveSupport::Concern
      
      # Whatever is inside of the included block will get executed 
      # in the class context of the class where the module is included.
      included do

      end
      
      module ClassMethods

        def self.to_csv(options = {})
          ::CSV.generate(options) do |csv|
            csv << column_names
            all.each do |m|
              csv << m.attributes.values_at(*column_names)
            end
          end
        end

      end#ClassMethods

    end #BelongsToSite
  end #Models
end #CvsExport
ActiveRecord::Base.send :include, Extensions::Models::CvsExport

