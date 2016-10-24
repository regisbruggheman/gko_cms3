# Extends has_one associations to allow for a :default option.
#
# This will make the page.article association always build a default article
# unless an article is already set or persisted.
#
#    class Page < ActiveRecord::Base
#      has_one :article, :default => :build_default_article
#
#      def build_default_article
#        build_article(:title => 'default title', :body => 'default body')
#      end
#    end
#
# Note that we also include a default scope that includes the associated record
# to avoid n+1 queries.

module ActiveRecord
  module Associations
    module HasOneDefault
      def has_one(association_id, options = {})
        default = options.delete(:default)
        super
        has_one_default(association_id, default) if default
      end

      def has_one_default(association_id, default)
        default_scope includes(:content) rescue nil # would raise during migrations. how to remove the rescue clause?
        validates_presence_of :content_id

        define_method(:content_with_default) do
          send(:content_without_default) || send(:"content=", send(default))
        end
        alias_method_chain :content, :default
        
        content_attributes = Content.content_columns.map(&:name)
        # define the attribute accessor method
        def content_attr_accessor(*attribute_array)
          attribute_array.each do |att|
            define_method(att) do
              content.send(att)
            end
            define_method("#{att}=") do |val|
              content.send("#{att}=",val)
            end
          end
        end
        content_attr_accessor *content_attributes
        
      end

      ActiveRecord::Base.extend(self)
    end
  end
end

