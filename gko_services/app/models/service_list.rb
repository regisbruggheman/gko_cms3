class ServiceList < Section
  include Extensions::Models::IsList
  has_many :services, :foreign_key => 'section_id', :dependent => :destroy, :order => 'published_at DESC'

  def content_type
    "Service"
  end
end
