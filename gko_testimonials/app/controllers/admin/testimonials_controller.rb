class Admin::TestimonialsController < Admin::ResourcesController
  respond_to :html
  nested_belongs_to :site, :testimonial_list
end