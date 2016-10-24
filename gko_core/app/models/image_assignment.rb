class ImageAssignment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true, :touch => true #FIXME , :counter_cache => true
  belongs_to :image, :counter_cache => true
  
  attr_accessible :attachable_type, :attachable_id, :image_id, :image
  
  default_scope :order => 'image_assignments.position'
  acts_as_list :scope => [:attachable_id, :attachable_type]
  validates_presence_of :attachable_id, :attachable_type, :image_id
  delegate :title, :alt, :to => :image, :prefix => false

  #----- Instance methods -----------------------------------------------------
  # Using polymorphic associations in combination with single
  # table inheritance (STI) is a little tricky.
  # In order for the associations to work as expected, ensure
  # that you store the base model for the STI models
  # in the type column of the polymorphic association.
  # For rails 3.2
  def attachable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end

end
