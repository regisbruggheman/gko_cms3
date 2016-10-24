require 'active_support/concern'

module Extensions
  module Models
    module Translatable

      extend ActiveSupport::Concern

      included do

      end

      module ClassMethods

        # Wrap up the logic of finding the pages based on the translations table.
        def with_globalize(conditions = {})
          conditions = {:locale => ::Globalize.locale}.merge(conditions) unless conditions.key?(:locale)
          globalized_conditions = {}
          conditions.keys.each do |key|
            if (translated_attribute_names.map(&:to_s) | %w(locale)).include?(key.to_s)
              globalized_conditions["#{self.translation_class.table_name}.#{key}"] = conditions.delete(key)
            end
          end
          # A join implies readonly which we don't really want.
          joins(:translations).where(globalized_conditions).where(conditions).readonly(false)
        end

      end #ClassMethods

      def labelize
        @label ||= [:title, :name].find { |m| self.respond_to?(m) }
        translated_locales.include?(Globalize.locale) ? self.send(@label) : "<span class='label warning'>!</span>(#{read_attribute(@label, :locale => I18n.default_locale)})".html_safe
      end

      def labelize_with_indent
        if self.class.respond_to?(:acts_as_nested_set)
          "#{"..." * self.level} #{labelize}".html_safe
        end
      end

    end # Translatable
  end # Models
end # Extensions
