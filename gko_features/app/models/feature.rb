class Feature < ActiveRecord::Base
  
  TRANSLATED_FIELD = [
    :title, :body
  ].freeze

  translates *TRANSLATED_FIELD

  class Translation
    attr_accessible :locale
  end

  attr_accessible :owner_id, :body, :title, :owner_type, :url, :image
  
  belongs_to_site :touch => true
  include Extensions::Models::Translatable
  include Extensions::Models::Publishable
  acts_as_list :scope => [:site_id]
  default_scope :order => 'features.position'
  belongs_to :owner, :polymorphic => true
  image_accessor :image
  # What is the max image size a user can upload
  MAX_SIZE_IN_MB = 1
  # What is the max image format a user can upload
  FILE_TYPES = %w(image/jpg image/jpeg image/png image/gif)

  def self.with_title(q)
    with_globalize(:title => q)
  end
  
  def self.live(conditions = {})
    published.with_globalize(conditions)
  end
  
  def owner_name
    owner.title if owner
  end

  def link
    return url if url.present?
    return owner_name
  end

  def thumbnail(geometry = nil)
    geometry ||= self.site.preferred_features_image_size
    image.thumb(geometry) if image.present?
  end
end
