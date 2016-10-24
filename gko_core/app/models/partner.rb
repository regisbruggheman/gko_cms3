class Partner < ActiveRecord::Base
  include Extensions::Models::BelongsToSection
  include Extensions::Models::Categorizable
  acts_as_list :scope => [:section_id]
  image_accessor :image
  translates :body
  default_scope :order => 'partners.position'

  # What is the max image size a user can upload
  MAX_SIZE_IN_MB = 1
  # What is the max image format a user can upload
  FILE_TYPES = %w(image/jpg image/jpeg image/png image/gif)

  attr_accessible :title, :body, :link, :position, :image, :image_size

  delegate :size, :mime_type, :url, :width, :height, :to => :image, :allow_nil => true

  class << self
    def trackable?
      false
    end
  end

  validates :image, :length => {:maximum => MAX_SIZE_IN_MB.megabytes}
  validates :link, :url => true, :allow_blank => true

  validates_property :mime_type, :of => :image, :in => FILE_TYPES,
                     :message => :incorrect_file_type


  def thumbnail(geometry = nil)
    if image.present?
      g = geometry || self.section.children_thumb_size
      image.thumb(g)
    end
  end

  def trackable?
    self.class.trackable?
  end
end
