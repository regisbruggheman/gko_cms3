class SectionSweeper < Gko::Sweeper
  observe Section

  def after_create(section)
    expire_site_cache(section.site)
  end

  def after_update(section)
    expire_site_cache(section.site)
  end

  def after_destroy(section)
    expire_site_cache(section.site)
  end
end