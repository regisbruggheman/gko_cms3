module Extensions
  module Controllers
    module Localize

      extend ActiveSupport::Concern

      included do # Extend controller
        prepend_before_filter :set_locale
        helper_method :current_language
      end

      protected

      def set_locale
        I18n.locale = (params.key?(:locale) ? params[:locale] : site.default_locale)
        if site.languages.published.find_by_code(locale)
          I18n.locale = session[:locale] = locale  
        else
          I18n.locale = site.default_locale
          error_404
        end
      end

      def current_language
        site.languages.find_by_code(I18n.locale)
      end

    end # Localize
  end # Controllers
end # Extensions
