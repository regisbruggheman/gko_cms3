class ImageBank < Section
  include Extensions::Models::IsList
  has_many :image_bank_photos, :foreign_key => "section_id",  :dependent => :destroy

  def photos_cached_key
    Digest::MD5.hexdigest("photos-#{self.image_bank_photos.maximum(:updated_at)}.try(:to_i)-#{self.image_bank_photos.count}")
  end
  
  def content_type
    "ImageBankPhoto"
  end
 
end