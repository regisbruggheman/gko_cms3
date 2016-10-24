class FaqElementSweeper < Gko::Sweeper
  observe FaqElement

  def after_create(element)
    expire_cache(element)
  end

  def after_update(element)
    expire_cache(element)
  end

  def after_destroy(element)
    expire_cache(element)
  end

  protected
  def expire_cache(element)
    expire_section_cache(element.section)
  end
end

