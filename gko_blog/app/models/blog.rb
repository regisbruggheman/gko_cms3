class Blog < Section
  include Extensions::Models::IsList
  
  has_many :posts, :foreign_key => 'section_id', :dependent => :destroy, :order => 'published_at DESC'
  
  def content_type
    "Post"
  end

end
