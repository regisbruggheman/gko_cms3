class DocumentItem < ActiveRecord::Base
  include Extensions::Models::BelongsToSection
  image_accessor :image
  document_accessor :document
  
  default_scope :order => 'document_items.published_at DESC'
  
  # What is the max document size a user can upload
  MAX_SIZE_IN_MB = 5
  # What is the max document format a user can upload
  FILE_TYPES = %w(application/pdf)
  
  attr_accessible :document, :body, :site_id, :document, :image, :language, :title, :country, :published_at
  
  delegate :size, :mime_type, :url, :width, :height, :name, :ext, :uid, :to => :document

  class << self
    def image_size
      'x210'
    end

    def trackable?
      false
    end

    def with_language(locale)
      locale ||= ::Globalize.locale
      where("document_items.language = ?", locale.to_s)
    end
  end
  
  validates :title, :document, :presence => true
  #validates_property :mime_type, :of => :image, :in => FILE_TYPES,
  #                   :message => :incorrect_image_type

  def thumbnail(geometry = nil)
    if image.present?
      geometry ||= self.section.thumbs_size
      image.thumb(geometry)
    end
  end

  def trackable?
    self.class.trackable?
  end
end
