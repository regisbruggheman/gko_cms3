# encoding: utf-8

module Gko
  class AssetUploader < ::CarrierWave::Uploader::Base

    include Gko::CarrierWave::Uploader::Asset

    def store_dir
      self.build_store_dir('uploads', 'sites', model.site_id, 'assets', model.id)
    end

  end
end