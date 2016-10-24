Site.class_eval do
  has_many :blogs
  has_many :posts, :through => :blogs
  
  def blog
    blogs.first
  end
end
