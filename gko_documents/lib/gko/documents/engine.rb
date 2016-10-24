module Gko
  module Documents
    class Engine < ::Rails::Engine
      include Gko::Engine

      engine_name :gko_documents

      initializer 'gko.documents.require_section_types' do
        config.to_prepare do
          require_dependency 'document_list'
        end
      end

      initializer 'gko.documents.dragonfly', :before => :load_config_initializers do |app|
        app_files = ::Dragonfly[:documents]
        app_files.configure_with(:rails) do |c|
          c.datastore.root_path = Rails.root.join('public', 'system', 'documents').to_s
          # defaults to false
          # This url_format makes it so that dragonfly urls work in traditional
          # situations where the filename and extension are required, e.g. lightbox.
          # What this does is takes the url that is about to be produced e.g.
          # /system/images/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw
          # and adds the filename onto the end (say the file was 'gko_is_awesome.pdf')
          # /system/documents/BAhbB1sHOgZmIiMyMDEwLzA5LzAxL1NTQ19DbGllbnRfQ29uZi5qcGdbCDoGcDoKdGh1bWIiDjk0MngzNjAjYw/gko_is_awesome.pdf
          c.url_format = '/system/documents/:job/:basename.:format'

          #c.secret = Array.new(24) { rand(256) }.pack('C*').unpack('H*').first
        end

        app_files.define_macro(::ActiveRecord::Base, :document_accessor)
        app_files.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
        app_files.content_disposition = :inline

        ### Extend active record ###

        app.config.middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :documents

        app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
            :verbose => Rails.env.development?,
            :metastore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'meta')}",
            :entitystore => "file:#{Rails.root.join('tmp', 'dragonfly', 'cache', 'body')}"
        }
      end

      initializer "gko.documents.register.plugin" do
        Gko::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'documents'
          plugin.version = %q{2.0.0}
          plugin.menu_match = %r{gko/documents(s_dialog)?s$}
          plugin.hide_from_menu = false
          plugin.always_allow_access = true
          plugin.icon = 'file'
          plugin.url = proc { Rails.application.routes.url_helpers.admin_site_documents_path(Site.current) }
        end
      end
      
      config.after_initialize do
        Gko.register_engine(Gko::Documents)
      end
    end
  end
end

