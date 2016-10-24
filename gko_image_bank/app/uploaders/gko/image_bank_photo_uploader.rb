# encoding: utf-8

module Gko
  class ImageBankPhotoUploader < ::CarrierWave::Uploader::Base

    include Gko::CarrierWave::Uploader::Asset

    def store_dir
      self.build_store_dir('uploads', 'sites', model.site_id, 'image_bank_photos', model.id)
    end

    version :thumb do
      process :resize_to_fit => [0,120]
    end
  end
end