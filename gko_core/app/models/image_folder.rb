class ImageFolder < ActiveRecord::Base

  include Extensions::Models::TouchAncestors
  
  attr_accessible :name, :parent_id
  # Note : we do not touch site when a folder is updated
  # because we use folders only in admin namespace
  belongs_to :site, :inverse_of => :image_folders

  acts_as_nested_set :dependent => :destroy, :scope => [:site_id]

  has_and_belongs_to_many :images, :uniq => true

  validates :site_id,
            :presence => true
  validates :name,
            :presence => true,
            :uniqueness => {:scope => [:site_id, :parent_id]}
  
  def self.nested_set
    order('lft ASC')
  end

  def self.cached_key(site = Site.current)
    Digest::MD5.hexdigest "admin-#{Globalize.locale}-image_folders-#{site.image_folders.maximum(:updated_at)}.try(:to_i)-#{site.image_folders.count}"
  end
  
  def images_timestamp
    "#{self.images.maximum(:updated_at)}.try(:to_i)-#{self.images.count}"
  end
end
