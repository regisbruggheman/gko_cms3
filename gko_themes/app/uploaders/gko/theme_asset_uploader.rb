# encoding: utf-8

module Gko
  class ThemeAssetUploader < ::CarrierWave::Uploader::Base

    include Gko::CarrierWave::Uploader::Asset

    def store_dir
      self.build_store_dir('sites', model.site_id, 'theme', model.folder)
    end

    def extension_white_list
      %w(jpg jpeg gif png css scss js coffee swf flv eot svg ttf woff otf ico htc)
    end

    def self.url_for(site, path)
      build(site, path).url
    end

    def self.build(site, path)
      asset     = site.theme_assets.build(:folder => File.dirname(path))
      uploader  = Gko::ThemeAssetUploader.new(asset)
      uploader.retrieve_from_store!(File.basename(path))
      uploader
    end

  end
end