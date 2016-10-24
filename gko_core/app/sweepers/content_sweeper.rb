class ContentSweeper < Gko::Sweeper
  observe Content

  def after_create(content)
    expire_content_cache(content)
  end

  def after_update(content)
    expire_content_cache(content)
  end

  def after_destroy(content)
    expire_content_cache(content)
  end
end
