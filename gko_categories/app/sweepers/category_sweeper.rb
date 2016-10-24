class CategorySweeper < Gko::Sweeper
  observe Category

  def after_create(category)
    expire_category_cache(category)
  end

  def after_update(category)
    expire_category_cache(category)
  end

  def after_destroy(category)
    expire_category_cache(category)
  end

  def expire_category_cache(category)
    expire_section_cache(category.section)
  end
end
