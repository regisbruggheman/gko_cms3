class FaqPage < Section
  include Extensions::Models::IsList
  has_many :faq_elements, :foreign_key => 'section_id', :dependent => :destroy, :order => 'contents.position DESC'

  def content_type
    "FaqElement"
  end

end