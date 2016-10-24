class NewsletterList < Section
  
    include Extensions::Models::IsList
    
  has_many :newsletters, :foreign_key => 'section_id', :dependent => :destroy, :order => 'published_at DESC'

  def content_type
    "Newsletter"
  end

end
