# Copy of Locale filter of RoutingFilter gem to set I18.locale in 'around_recognize' or sometimes a bug occures in 'section_path' where locale is default locale even if locale is different.

# The Locale filter extracts segments matching /:locale from the beginning of
# the recognized path and exposes the page parameter as params[:page]. When a
# path is generated the filter adds the segments to the path accordingly if
# the page parameter is passed to the url helper.
#
#   incoming url: /de/products/page/1
#   filtered url: /de/products
#   params:       params[:locale] = 'de'
#
# You can install the filter like this:
#
#   # in config/routes.rb
#   Rails.application.routes.draw do
#     filter :locale
#   end
#
# To make your named_route helpers or url_for add the pagination segments you
# can use:
#
#   products_path(:locale => 'de')
#   url_for(:products, :locale => 'de'))

require 'i18n'

module RoutingFilter
  class Localize < Filter
    @@include_default_locale = false # Set to true to include default locale in url
    cattr_writer :include_default_locale

    class << self
      def include_default_locale?
        @@include_default_locale
      end

      def locales_pattern
        #@@locales_pattern ||= %r(^/(#{self.locales.map { |l| Regexp.escape(l.to_s) }.join('|')})(?=/|$))
        @@locales_pattern ||= %r(^/(#{Language.pluck(:code).uniq.map { |l| Regexp.escape(l.to_s) }.join('|')})(?=/|$))
      end
    end

    def around_recognize(path, env, &block)
      if site(env)
        if @site.language_codes.count > 1
          locales_pattern = %r(^/(#{@site.language_codes.map { |l| Regexp.escape(l.to_s) }.join('|')})(?=/|$))
          #locale = extract_segment!(self.class.locales_pattern, path) # remove the locale from the beginning of the path
          locale = extract_segment!(locales_pattern, path) # remove the locale from the beginning of the path
        end
        locale ||= (@site.default_locale || I18n.default_locale)
        I18n.locale = locale if locale
        yield.tap do |params| # invoke the given block (calls more filters and finally routing)
          params[:locale] = locale if locale # set recognized locale to the resulting params hash
        end
      end

    end

    def around_generate(*args, &block)
      # this is because we might get a call like forum_topics_path(forum, topic, :locale => :en)
      params = args.extract_options!
      # extract the passed :locale option
      locale = params.delete(:locale)
      # default to I18n.locale when locale is nil (could also be false)
      locale = I18n.locale if locale.nil?
      # reset to no locale when locale is not valid
      locale = nil unless valid_locale?(locale)
      
      args << params

      yield.tap do |result|
        if prepend_locale?(locale) and !excluded?(result)
          prepend_segment!(result, locale)
        end
      end
    end

    protected

    def site(env)
      @site ||= Site.includes([:languages, :translations]).by_host(host(env))
    end
    
    def valid_locale?(locale)
      Site.current.language_codes.map(&:to_sym).include?(locale.to_sym)
    end

    def default_locale?(locale)
      locale && locale.to_sym == @site.default_locale
    end

    def prepend_locale?(locale)
      locale && (self.class.include_default_locale? || !default_locale?(locale))
    end
  end
end
