class AlbumList < Section
  include Extensions::Models::IsList
  has_many :albums, :foreign_key => 'section_id', :dependent => :destroy


  def albums_cached_key
    Digest::MD5.hexdigest("albums-#{self.albums.maximum(:updated_at)}.try(:to_i)-#{self.albums.count}")
  end

  #def cached_live_albums(conditions={})
  #  if conditions.empty? 
  #    k = [Globalize.locale, "live-albums", self.id, albums_cached_key]
  #  else
  #    k = [Globalize.locale, "live-albums", conditions.to_query, self.id, albums_cached_key]
  #  end
  #  Rails.cache.fetch k.join('/') do
  #    self.albums.live(conditions).all
  #  end
  #end
  
  def content_type
    "Album"
  end
end
