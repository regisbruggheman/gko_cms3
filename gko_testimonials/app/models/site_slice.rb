Site.class_eval do
  has_many :testimonial_lists
  has_many :testimonials, :through => :testimonial_lists
end