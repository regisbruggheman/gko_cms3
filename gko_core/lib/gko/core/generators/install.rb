module Gko
  module Generators
    class Install
      include Thor::Shell

      attr_reader :engines

      def initialize(engines)
        self.engines = engines
      end

      def invoke
        engines.each do |engine|
          engine.new.copy_migrations.each do |path|
            say_status('copy migration', File.basename(path), :green)
          end
        end
      end

      protected

      def engines=(engines)
        engines = Array(engines)
        engines = Gko.engines if engines.blank? || engines.include?(:all)
        engines = engines.map { |engine| engine.is_a?(Class) ? engine : Gko.const_get(engine.to_s.classify) }
        engines.unshift(Gko::Core) unless engines.include?(Gko::Core)
        @engines = engines.uniq
      end
    end
  end
end
