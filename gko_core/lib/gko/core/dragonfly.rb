module Gko
  module Core
    module Dragonfly

      class << self
        def setup!
          app_images = ::Dragonfly[:images]
          app_images.configure_with(:imagemagick) # defaults to false
          app_images.configure_with(:rails) do |c|
            c.datastore.root_path = Rails.root.join('public', 'system', 'images').to_s
            c.url_format = '/system/images/:job/:basename.:format'
            c.secret = Gko::Core.dragonfly_secret
            c.trust_file_extensions = Gko::Core.trust_file_extensions
            # Custom job process
            # Job shortcut - lets you do image.black_and_white('30x30')
            c.job :black_and_white do |size|
              process :greyscale
              process :thumb, size
            end
          end
          app_images.define_macro(::ActiveRecord::Base, :image_accessor)
          app_images.analyser.register(::Dragonfly::ImageMagick::Analyser)
          app_images.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)

          app_files = ::Dragonfly[:documents]
          app_files.configure_with(:rails) do |c|
            c.datastore.root_path = Rails.root.join('public', 'system', 'documents').to_s
            c.url_format = '/system/documents/:job/:basename.:format'
          end
          app_files.define_macro(::ActiveRecord::Base, :document_accessor)
          app_files.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
          app_files.content_disposition = :attachment
        end

        def attach!(app)
          ### Extend active record ###
          app.config.middleware.insert_before 'ActionDispatch::Callbacks', 'Dragonfly::Middleware', :images
          app.config.middleware.insert_before 'ActionDispatch::Callbacks', 'Dragonfly::Middleware', :documents

          app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
            :verbose => Rails.env.development?,
            :metastore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
            :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
          }
        end
      end

    end
  end
end
