require 'active_support/concern'

module Extensions
  module Models
    module Sluggable
      
      extend ActiveSupport::Concern
      
      included do
        translates :meta_description, :meta_title, :slug
        include Extensions::Models::Translatable
        attr_accessible :meta_description, :meta_title, :slug
        before_validation :normalize_slug
      end
      
      module ClassMethods

        def with_title(q)
          joins(:translations).where("#{self.translation_class.table_name}.title LIKE ?", "%#{q}%")
        end
        alias_method :with_query, :with_title

        def by_permalink(slug)
          with_globalize(:slug => slug)
        end
        
        def trackable?
          true
        end
      end #ClassMethods
      
      def trackable?
        self.class.trackable?
      end
      
      def permalink(locale=nil)
        locale ||= ::Globalize.locale
        read_attribute(:slug, :locale => locale)
      end

      def to_param(title=nil)
        title == :permalink ? permalink : super()
      end

      # Get all public urls for all locales
      def public_urls
        urls = []
        self.used_locales.each do |l|
          urls << self.public_url(l)
        end
        urls.flatten.compact.uniq
      end
      
      # Used for hint in admin space and cache
      # Warn : Permalink can be blank if it is not published
      def public_url(locale=nil)
        locale ||= ::Globalize.locale
        
        p = self.permalink(locale)
        return nil unless p.present?
        u = [self.section.path(locale), p]
        u.unshift(locale.to_s) if (locale.to_sym != site.default_locale.to_sym)
        u = u.join('/')
        u = '/' + u
        u
      end

      # The canonical page for this particular page.
      # Consists of:
      #   * The default locale's translated slug
      def canonical
        Globalize.with_locale(site.default_locale) { slug }
      end
      
      protected
      
      def normalize_slug
        self.slug = self.title.clone if self.slug.blank? && self.title.present?
        self.slug = transliterate_slug(self.slug) if slug_changed? && self.slug.present?
      end
      
      def transliterate_slug(input)
        transliteration = case ::Globalize.locale.to_sym
          #when :bg  then :bulgarian
          #when :da  then :danish
          when :de  then :german
          #when :gr  then :greek
          #when :mk  then :macedonian
          #when :no  then :norwegian
          #when :ro  then :romanian
          when :ru  then :russian
          #when :bg  then :serbian
          when :pt  then :spanish
          when :br  then :spanish
          when :es  then :spanish
          #when :se  then :swedish
        end
        if transliteration.presence
          input.to_s.to_slug.normalize(:transliterate => true, :transliterations => transliteration).to_s
        else
          input.to_s.to_slug.normalize.to_s
        end
      end

    end #Sluggable
  end #Shared
end #Extensions
