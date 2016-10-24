class SiteSweeper < Gko::Sweeper
  observe Site

  def after_update(site)
    expire_site_cache(site)
  end

  def after_destroy(site)
    expire_site_cache(site)
  end
end

