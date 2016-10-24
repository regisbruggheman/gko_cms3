class Testimonial < ActiveRecord::Base
  default_scope :order => 'testimonials.title'

  TRANSLATED_FIELD = [
    :title, :body, :excerpt, :meta_description, :meta_title, :slug
  ].freeze

  translates *TRANSLATED_FIELD

  class Translation
    attr_accessible :locale
  end
  
  attr_accessible (:body, 
    :title, 
    :name, 
    :excerpt, 
    :author, 
    :company)

  include Extensions::Models::BelongsToSection
  include Extensions::Models::Sluggable
  include Extensions::Models::HasManyImageAssignments 

  validates :title, :presence => true, :uniqueness => {:scope => :section_id, :case_sensitive => false}

  # Indicate if this page should be included in robot.txt
  # use trackable? rather than checking the attribute directly. this
  # allows sub-classes to override trackable? if they want to provide
  # their own definition.
  def trackable?
    true
  end
end 
