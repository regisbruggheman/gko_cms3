class Asset < ActiveRecord::Base

  ## extensions ##
  belongs_to_site
  include Extensions::Models::AssetContentTypes
  
  ## fields ##
  attr_accessible(
    :content_type,
    :width,
    :height,
    :size,
    :source)

  ## validations ##
  validates_presence_of :source

  ## behaviours ##
  mount_uploader :source, Gko::AssetUploader

  ## methods ##
  #alias :name :source

  def extname
    return nil unless self.source?
    File.extname(self.source_filename).gsub(/^\./, '')
  end

  #def to_liquid
  #  { :url => self.source.url }.merge(self.attributes).stringify_keys
  #end

  #def as_json(options = {})
  #  Locomotive::ContentAssetPresenter.new(self).as_json
  #end

end
