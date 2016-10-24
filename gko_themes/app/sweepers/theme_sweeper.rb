class Admin::ThemeSweeper < Gko::Sweeper
  observe Theme

  def after_update(theme)
    expire_site_cache(current_site)
  end
end
