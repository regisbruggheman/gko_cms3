require 'routing_filter'

# If the path is, aside from a slash and an optional locale, the leftmost part
# of the path, replace it by "sections/:id" segments.

module RoutingFilter
  class SectionPath < Filter

    def around_recognize(path, env, &block)
      if !excluded?(path) and site(env)
        search, replace = recognition(path)
        path.sub!(%r(^/([\w]{2,4}/)?(#{search})(?=/|\.|\?|$)), "/#{$1}#{replace}#{$3}") if search
      end
      yield
    end

    def around_generate(params, &block)
      yield.tap do |path|
        path = path.to_s
        if !excluded?(path)
          search, replace = *generation(path)
          path.sub!(search) { "#{replace}#{$3}" } if search
          path.replace("/#{path}") unless path[0, 1] == '/'
          return path, {} #return params as nil !! rails 3.2.2
        end
      end
    end

    protected

    def recognition(path)
      if path =~ recognition_pattern and section = @site.cached_live_sections(:path => $2).first
        [$2, "#{$1}#{section.type.tableize}/#{section.id}"]
      end
    end

    def recognition_pattern
      paths = @site.cached_live_sections.map(&:path).reject(&:blank?)
      paths = paths.sort { |a, b| b.size <=> a.size }.join('|')
      paths.empty? ? %r(^$) : %r(^/([\w]{2,4}/)?(#{paths})(?=/|\.|\?|$))
    end

    def generation(path)
      if path =~ section_pattern and section = Site.current.cached_live_sections(:id => $2.to_i).first
        ["/#{$1}/#{$2}", "#{section.path}#{$3}"]
      end
    end

  end
end