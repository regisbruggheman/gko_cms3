class PartnerSweeper < Gko::Sweeper
  observe Partner

  def after_create(partner)
    expire_cache(partner)
  end

  def after_update(partner)
    expire_cache(partner)
  end

  def after_destroy(partner)
    expire_cache(partner)
  end

  protected
  def expire_cache(partner)
    expire_section_cache(partner.section)
  end
end

