class StickerSweeper < Gko::Sweeper
  observe Sticker

  def after_create(sticker)
    expire_sticker_cache(sticker)
  end

  def after_update(sticker)
    expire_sticker_cache(sticker)
  end

  def after_destroy(sticker)
    expire_sticker_cache(sticker)
  end

  def expire_sticker_cache(sticker)
    expire_section_cache(sticker.section)
  end
end
