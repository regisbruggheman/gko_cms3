require 'rails/engine'

module Gko

  autoload :Engine, 'gko/engine'

  class << self
    @@engines = []

    attr_accessor :base_cache_key

    # Used to configure Gko.
    #
    # Example:
    #
    #   Gko.config do |config|
    #     config.site_name = "An awesome Gko site"
    #   end
    #
    # This method is defined within the core gem on purpose.
    # Some people may only wish to use the Core part of Gko.
    def config(&block)
      yield(Gko::Config)
    end

    def base_cache_key
      @base_cache_key ||= :gko
    end

    # Returns an array of modules representing currently registered Gko Engines
    #
    # Example:
    #   Gko.engines  =>  [Gko::Core, Gko::Pages]
    def engines
      @@engines
    end

    
    def engine_names
      @engine_names ||= engines.map { |constant| constant.name.split('::').last.underscore.to_sym }
    end

    
    # Register an engine with Gko
    #
    # Example:
    #   Gko.register_engine(Gko::Core)
    def register_engine(const)
      return if engine_registered?(const)
      validate_engine!(const)
      @@engines << const
    end

    # Unregister an engine from Gko
    #
    # Example:
    #   Gko.unregister_engine(Gko::Core)
    def unregister_engine(const)
      @@engines.delete(const)
    end

    # Returns true if an engine is currently registered with Gko
    #
    # Example:
    #   Gko.engine_registered?(Gko::Core)
    def engine_registered?(const)
      @@engines.include?(const)
    end

    alias :engine? :engine_registered?

    # Returns a Pathname to the root of the Gko project
    def root
      @root ||= Pathname.new(File.expand_path('../../../../', __FILE__))
    end

    # Returns an array of Pathnames pointing to the root directory of each engine that
    # has been registered with Gko.
    #
    # Example:
    #   Gko.roots => [#<Pathname:/Users/Reset/Code/gko/core>, #<Pathname:/Users/Reset/Code/gko/pages>]
    #
    # An optional engine_name parameter can be specified to return just the Pathname for
    # the specified engine. This can be represented in Constant, Symbol, or String form.
    #
    # Example:
    #   Gko.roots(Gko::Core)    =>  #<Pathname:/Users/Reset/Code/gko/core>
    #   Gko.roots(:'gko/core')  =>  #<Pathname:/Users/Reset/Code/gko/core>
    #   Gko.roots("gko/core")   =>  #<Pathname:/Users/Reset/Code/gko/core>
    def roots(engine_name = nil)
      return @roots ||= self.engines.map { |engine| engine.root } if engine_name.nil?

      engine_name.to_s.camelize.constantize.root
    end

    private
    def validate_engine!(const)
      unless const.respond_to?(:root) && const.root.is_a?(Pathname)
        raise InvalidEngineError, "Engine must define a root accessor that returns a pathname to its root"
      end
    end

  end
end


