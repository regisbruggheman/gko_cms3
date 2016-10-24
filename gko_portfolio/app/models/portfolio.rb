class Portfolio < Section
  include Extensions::Models::IsList
  has_many :projects, :foreign_key => 'section_id', :order => 'contents.position', :dependent => :destroy

  def content_type
    "Project"
  end
  
end
