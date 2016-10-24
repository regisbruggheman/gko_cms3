module Gko
  module CarrierWave
    module Uploader
      module Simple

        extend ActiveSupport::Concern

        included do

          # Include RMagick or MiniMagick support:
          include ::CarrierWave::RMagick
          #include CarrierWave::MiniMagick

          # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
          include ::Sprockets::Helpers::RailsHelper
          include ::Sprockets::Helpers::IsolatedHelper

          # Choose what kind of storage to use for this uploader:
          storage :file
          # storage :fog
          
          # Add a white list of extensions which are allowed to be uploaded.
          # For images you might use something like this:
          def extension_white_list
            %w(jpg jpeg gif png)
          end
          
         
        end
        
      end  # Simple
    end # Uploader
  end # CarrierWave
end # Gko