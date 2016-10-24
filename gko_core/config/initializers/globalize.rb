Globalize::ActiveRecord::Adapter.class_eval do
  def fetch(locale, name)
    record.globalize_fallbacks(locale).each do |fallback|
      value = stash.contains?(fallback, name) ? fetch_stash(fallback, name) : fetch_attribute(fallback, name)

      unless fallbacks_for?(value)
        set_metadata(value, :locale => fallback, :requested_locale => locale)
        return value
      end
    end
    return ""
    #return nil
  end
end