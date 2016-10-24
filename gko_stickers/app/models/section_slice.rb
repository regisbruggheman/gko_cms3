Section.class_eval do
  has_many :stickers, :dependent => :destroy, :foreign_key => :section_id
  has_option :accept_stickers, :default => false, :type => :boolean
  
  def sticking_cached_key
    Digest::MD5.hexdigest("sticking-#{self.stickers.maximum(:updated_at)}.try(:to_i)-#{self.stickers.count}")
  end
end
