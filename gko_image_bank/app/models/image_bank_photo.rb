class ImageBankPhoto < ActiveRecord::Base

  belongs_to :image_bank, :foreign_key => "section_id", :touch => true
  
  default_scope :order => 'image_bank_photos.position ASC'
  
  ## extensions ##
  include Extensions::Models::BelongsToSection
  include Extensions::Models::AssetContentTypes
  include Extensions::Models::Categorizable
  
  ## fields ##
  attr_accessible(
    :content_type,
    :width,
    :height,
    :size,
    :source,
    :author)

  ## validations ##
  validates_presence_of :source

  ## behaviours ##
  mount_uploader :source, Gko::ImageBankPhotoUploader
  acts_as_list :scope => [:section_id]
  
  ## class methods ##
  def self.trackable?
    false
  end

  
  ## instance methods ##
  def trackable?
    self.class.trackable?
  end
  
  def extname
    return nil unless self.source?
    File.extname(self.source_filename).gsub(/^\./, '')
  end

end

