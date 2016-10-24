require 'routing_filter'
RoutingFilter::Filter.class_eval do

    cattr_accessor :default_port
    self.default_port = '80'

    cattr_accessor :exclude
    self.exclude = %r(^/admin|user|login|assets|javascripts|stylesheets/)

    protected

    def excluded?(path)
      path =~ exclude
    end

    def host(env)
      host, port = env.values_at('SERVER_NAME', 'SERVER_PORT')
      port == default_port ? host : [host, port].compact.join(':')
    end
    
    def site(env)
      @site ||= Site.includes([:languages, :translations]).with_globalize.by_host(host(env))
    end

    def generate_section_pattern
      @generate_pattern ||= %r(^(?:/[\w]{2})?(/(#{Section.types.map(&:tableize).join('|')})/([\d]+)(?:/|\.|\?|$)))
    end

    def section_pattern
      types = Section.types.map { |type| type.tableize }.join('|')
      %r(/(sections|#{types})/([\d]+(/?))(\.?))
    end
    
    def recognize_section_for(env, path, key)
      if site(env)
        if path =~ section_pattern
          @site.sections.live.find($2)
        elsif path =~ %r(^/#{key}/\w+)
          @site.sections.live.root
        end
      end
    end
end