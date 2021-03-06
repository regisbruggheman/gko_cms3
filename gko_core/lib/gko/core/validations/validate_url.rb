require 'uri'
require 'active_model'

module ActiveModel
  module Validations
    class UrlValidator < ActiveModel::EachValidator

      def initialize(options)
        options.reverse_merge!(:schemes => %w(http https))
        options.reverse_merge!(:message => "is not a valid URL")
        options.reverse_merge!(:require_subdomain => false)
        super(options)
      end

      def validate_each(record, attribute, value)
        schemes = [*options.fetch(:schemes)].map(&:to_s)

        if URI::regexp(schemes).match(value)
          begin
            uri = URI.parse(value)

            if options[:require_subdomain] && uri.host !~ /^(.+)\.(.+)$/
              record.errors.add(attribute, options.fetch(:message), :value => value)
            end
          rescue URI::InvalidURIError
            record.errors.add(attribute, options.fetch(:message), :value => value)
          end
        else
          record.errors.add(attribute, options.fetch(:message), :value => value)
        end
      end
    end

    module ClassMethods
      # Validates whether the value of the specified attribute is valid url.
      #
      #   class Unicorn
      #     include ActiveModel::Validations
      #     attr_accessor :homepage, :ftpsite
      #     validates_url :homepage, :allow_blank => true
      #     validates_url :ftpsite, :schemes => ['ftp']
      #   end
      # Configuration options:
      # * <tt>:message</tt> - A custom error message (default is: "is not a valid URL").
      # * <tt>:allow_nil</tt> - If set to true, skips this validation if the attribute is +nil+ (default is +false+).
      # * <tt>:allow_blank</tt> - If set to true, skips this validation if the attribute is blank (default is +false+).
      # * <tt>:schemes</tt> - Array of URI schemes to validate against. (default is +['http', 'https']+)

      def validates_url(*attr_names)
        validates_with UrlValidator, _merge_attributes(attr_names)
      end
    end
  end
end