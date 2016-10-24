# encoding: utf-8

module Gko
  class ThemeUploader < ::CarrierWave::Uploader::Base

    def store_dir
      "#{Rails.root}/tmp/themes"
    end

    def extension_white_list
      %w(zip)
    end

  end
end