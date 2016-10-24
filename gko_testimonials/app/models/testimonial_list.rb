class TestimonialList < Section
  include Extensions::Models::IsList
  has_many :testimonials, :foreign_key => 'section_id', :dependent => :destroy, :order => 'published_at DESC'

  def content_type
    "Testimonial"
  end
end
