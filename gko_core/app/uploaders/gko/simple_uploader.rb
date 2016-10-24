# encoding: utf-8

module Gko
  class SimpleUploader < ::CarrierWave::Uploader::Base

    include Gko::CarrierWave::Uploader::Simple

    def store_dir
      self.build_store_dir('uploads', 'sites', model.site_id, 'simples', model.id)
    end 
    
    #  to limit height only
    process :resize_to_limit => [300, 300]

  end
end