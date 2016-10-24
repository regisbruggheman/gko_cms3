Site.class_eval do
  has_many :album_lists
  has_many :albums, :through => :album_lists
end
