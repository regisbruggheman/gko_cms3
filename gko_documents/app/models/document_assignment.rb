class DocumentAssignment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true #FIXME , :counter_cache => true
  belongs_to :document, :counter_cache => true
  default_scope :order => 'document_assignments.position'
  acts_as_list :scope => [:attachable_id, :attachable_type]
  validates_presence_of :attachable_id, :attachable_type, :document_id
  delegate :title, :alt, :url, :to => :document, :prefix => false

  #----- Instance methods -----------------------------------------------------
  # Using polymorphic associations in combination with single
  # table inheritance (STI) is a little tricky.
  # In order for the associations to work as expected, ensure
  # that you store the base model for the STI models
  # in the type column of the polymorphic association.
  def attachable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end

  after_save do |r|
    r.attachable.touch #delete cached page
  end
end
