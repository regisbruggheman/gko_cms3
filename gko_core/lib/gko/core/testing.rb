module Gko
  module Testing
    autoload :Engine, 'gko/testing/engine'

    Rails::Engine.extend(Engine)

    class << self
      def setup(options = {})
        Gko.out = StringIO.new('')
        setup_logging(options)
        setup_active_record

        each_engine { |e| e.setup_load_paths }
        ActiveSupport::Slices.register

        each_engine { |e| e.new.require_patches }
        each_engine { |e| e.migrate }

        load_assertions
        load_factories
      end

      def each_engine(&block)
        Gko.engines.each(&block)
      end

      def load_assertions
        Gko.engines.each { |e| e.load_assertions }
      end

      def load_factories
        Gko.engines.each { |e| e.load_factories }
      end

      def load_cucumber_support
        Gko.engines.each { |e| e.load_cucumber_support }
      end

      def load_helpers
        Gko.engines.each { |e| e.load_helpers }
      end

      def setup_logging(options)
        if log = options[:log]
          FileUtils.touch(log) unless File.exists?(log)
          ActiveRecord::Base.logger = Logger.new(log)
          ActiveRecord::LogSubscriber.attach_to(:active_record)
        end
      end

      def setup_active_record
        ActiveRecord::Base.establish_connection(:adapter => 'mysql2', :database => ':memory:')
        ActiveRecord::Migration.verbose = false
        DatabaseCleaner.strategy = :truncation
      end
    end
  end
end
