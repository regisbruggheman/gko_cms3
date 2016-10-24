require File.join(File.dirname(__FILE__), 'middleware/flash_session_cookie')

module Gko
  module Core
    class Engine < ::Rails::Engine
      include Gko::Engine
      engine_name :gko_core
      config.autoload_paths += %W(#{config.root}/lib)

      def self.activate
      end

      config.to_prepare &method(:activate).to_proc

      initializer 'gko.core.application_configuration', :before => :load_config_initializers do |app|
        # Settings specified here will take precedence over those in config/application.rb
        # Configure the default encoding used in templates for Ruby 1.9.
        c = app.config
        c.encoding = "utf-8"
        c.assets.paths << Rails.root.join("app", "assets", "fonts")
        # Enable the asset pipeline
        c.assets.enabled = true
        if Rails.env.development?
          c.active_record.mass_assignment_sanitizer = :strict
          c.active_record.auto_explain_threshold_in_seconds = 0.5
          c.cache_classes = false
          c.whiny_nils = true
          c.action_controller.perform_caching = false
          c.action_mailer.raise_delivery_errors = false
          c.active_support.deprecation = :log
          c.action_dispatch.best_standards_support = :builtin
          c.assets.compress = false
          c.assets.debug = false
          c.consider_all_requests_local = true
          c.action_dispatch.show_exceptions = true
        elsif Rails.env.production?
          c.cache_classes = true
          c.consider_all_requests_local = false
          c.action_controller.perform_caching = true
          c.serve_static_assets = true
          c.assets.compress = true
          c.assets.compile = false
          c.assets.digest = true
          c.assets.precompile += %w( public.js public.css )
          c.active_support.deprecation = :notify
        elsif Rails.env.test?
          c.cache_classes = true
          c.serve_static_assets = true
          c.static_cache_control = "public, max-age=31536000"
          c.whiny_nils = true
          c.consider_all_requests_local = true
          c.action_controller.perform_caching = false
          c.action_dispatch.show_exceptions = false
          c.action_controller.allow_forgery_protection = false
          c.action_mailer.delivery_method = :test
          c.active_support.deprecation = :stderr
        end
      end

      initializer "gko.load_preferences", :before => "activesupport.slices.register" do
        ::ActiveRecord::Base.send :include, Gko::Preferences::Preferable
      end

      
      initializer 'gko.core.dragonfly', :before => :load_config_initializers do |app|
        Gko::Core::Dragonfly.setup!
        Gko::Core::Dragonfly.attach!(app)
      end

      initializer 'gko.flash_cookie' do |app|
        app.config.middleware.insert_after(
          'ActionDispatch::Cookies',
          Gko::Middleware::FlashSessionCookie,
          Rails.configuration.session_options[:key]
        )
      end
      
      # Really need that ? (engine should reload itself in development mode)
      initializer 'gko.require_section_types' do
        config.to_prepare do
          require_dependency 'page'
          require_dependency 'redirect'
          require_dependency 'partner_list'
          require_dependency 'faq_page'
        end
      end

      initializer "gko.core.register_page_types" do
        Gko::PageTypes.register('page', false)
        Gko::PageTypes.register('redirect', false)
        Gko::PageTypes.register('partner_list', false)
        Gko::PageTypes.register('faq_page', false)
      end
      
      # set the manifests and assets to be precompiled
      initializer "gko.assets.precompile" do |app|
        app.config.assets.precompile += Gko::Core.admin_precompile
      end

      # active model fields which may contain sensitive data to filter
      initializer "gko.params.filter" do |app|
        app.config.filter_parameters += [:email, :password, :password_confirmation]
      end

      initializer "gko.memory_store" do |app|
        app.config.cache_store = :memory_store
      end

      initializer 'gko.core.setup_acts_as_indexed' do |app|
        ActsAsIndexed.configure do |config|
          config.index_file = Rails.root.join('tmp', 'index')
          config.index_file_depth = 3
          config.min_word_size = 3
        end
      end

      initializer "gko.routes", :after => :initialize do |app|
        Rails.application.routes.append do
          app.routes.append{match '*admin/*path', :to => 'admin/base#error_404'}
          app.routes.append{match '*path', :to => 'base#error_404'}
        end
      end
      
      initializer "gko.detect.mobile", :after => :initialize do |app|
        app.config.middleware.use Mobvious::Manager
      end

      initializer 'gko.config-exception_notification' do |app|
        app.config.app_middleware.use ExceptionNotifier,
        :email_prefix => "[Exception] ",
        :sender_address => "no-reply@joufdesign.com",
        :exception_recipients => "admin@joufdesign.com"
      end if Rails.env.production?
    end
  end
end
