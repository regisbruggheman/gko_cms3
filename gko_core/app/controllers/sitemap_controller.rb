class SitemapController < BaseController
  respond_to :xml
  layout nil

  def index
    @default_locale = site.languages.get_default.code
    @available_locales = site.languages.published.order('languages.default DESC').map(&:code)
    @base_url = "#{request.protocol}#{request.host_with_port}"

    @sections = Rails.cache.fetch [I18n.locale, "sitemap", site.cache_key].join('/') do
      site.sections.nested_set.published.indexable.includes(:translations).arrange
    end

    
    unless (Rails.env.development? && local_request?) || (Rails.env.production? && site.public)
      render :nothing => true
    end
  end

end
