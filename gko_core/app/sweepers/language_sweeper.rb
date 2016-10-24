class LanguageSweeper < Gko::Sweeper
  observe Language

  def after_create(language)
    expire_site_cache(language.site)
  end

  def after_update(language)
    expire_site_cache(language.site)
  end

  def after_destroy(language)
    expire_site_cache(language.site)
  end
end

