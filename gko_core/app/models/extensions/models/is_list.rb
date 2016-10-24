require 'active_support/concern'

module Extensions
  module Models
    module IsList
      
      extend ActiveSupport::Concern
      
      included do
        has_option :display_contents_in_menu, :default => false, :type => :boolean
        has_option :contents_per_page, :default => 20, :type => :integer
        has_option :column_count, :default => 1, :type => :integer
        has_option :default_order, :default => "title", :type => :string
        has_option :listing_description_length, :default => 120, :type => :integer
        has_option :listing_omission, :default => "[...]", :type => :string
      end
      
      module ClassMethods

      end

    end #IsList
  end #Models
end #Extensions
