module Gko
  module CarrierWave
    module Uploader
      module Asset

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
          process :set_content_type
          process :set_size
          process :set_width_and_height
          version :compiled, :if => :wants_compilation? do
            process :compile_js_css
          end

        end

        module ClassMethods

          def content_types
            {
              :image      => ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg', 'image/x-icon'],
              :video      => [/^video/, 'application/x-shockwave-flash', 'application/x-flash-video', 'application/x-swf', /^audio/, 'application/ogg', 'application/x-mp3'],
              :pdf        => ['application/pdf', 'application/x-pdf'],
              :stylesheet => ['text/css'],
              :javascript => ['text/javascript', 'text/js', 'application/x-javascript', 'application/javascript', 'text/x-component'],
              :font       => ['application/x-font-ttf', 'application/vnd.ms-fontobject', 'image/svg+xml', 'application/x-woff'],
              :scss       => ['text/x-scss'],
              :coffeescript => ['text/x-coffeescript']
            }
          end

        end

        def set_content_type(*args)
          value = :other

          #content_type = file.content_type == 'application/octet-stream' ? File.mime_type?(original_filename) : file.content_type
content_type = file.content_type
          self.class.content_types.each_pair do |type, rules|
            rules.each do |rule|
              case rule
              when String then value = type if content_type == rule
              when Regexp then value = type if (content_type =~ rule) == 0
              end
            end
          end

          model.content_type = value
        end

        def set_size(*args)
          model.size = file.size
        end

        def set_width_and_height
          if model.image?
            magick = ::Magick::Image.read(current_path).first
            model.width, model.height = magick.columns, magick.rows
          end
        end

        def image?(file)
          model.image?
        end

        def wants_compilation?( text )
          model.respond_to?(:stylesheet_or_javascript?) and model.stylesheet_or_javascript? and model.compile?
        end
        
        def compile_js_css(*args)
          cache_stored_file! if !cached?
          pre_suffix = model.stylesheet? ? '.css' : '.js'
          path = model.source.path.to_s.gsub(/(\.scss|\.coffee)$/, "#{pre_suffix}\\1" )
          FileUtils.cp( model.source.path, path )
          # With using Sprockets we are able to import everything from gems or the app itself
          assets = Rails.application.assets
          # Sprockets uses a Cache on Production, but we need the version that allows us to append a path
          assets = assets.instance_variable_get('@environment') if assets.class == ::Sprockets::Index
          # we do not want to change something, so no index expiration
          assets.define_singleton_method('expire_index!', proc { false } )
          # append necessary paths
          ( Gko.config.assets_append_paths || [] ).each { |p| assets.append_path( p ) } 
          assets.append_path( File.dirname( path ) )
          assets.append_path( File.expand_path( model.source.store_dir,Rails.public_path ) )
          # and finaly compile all the stuff
          asset = ::Sprockets::ProcessedAsset.new( assets, path, Pathname.new(path) )
          asset.write_to( current_path )
          rescue
            raise ::CarrierWave::ProcessingError, "#{$!} #{$@}"
          end
      end
    end
  end
end
