require 'routing_filter'

module RoutingFilter
  class SectionRoot < Filter

    cattr_accessor :anchors
    self.anchors = %w(article)

    def around_recognize(path, env, &block)
      # p "#{self.class.name}: #{path}"
      if !excluded?(path) and site(env)
        search, replace = *recognition(host(env))
        path.sub!(search) { "#{$1}#{replace}#{$2}" } if search
      end
      yield
    end

    def around_generate(params, &block)
      yield.tap do |path|
        remove_root_section!(path) unless excluded?(path)
      end
    end

    protected

    def recognition(host)
      if root = @site.cached_live_sections(:parent_id => nil).first
        [%r(^(/[\w]{2})?(?:\/?)(?:index)?(#{anchors.join('|')}|\.|\?|/?\Z)), "/#{root.type.tableize}/#{root.id}"]
      end
    end

    def anchors
      @anchors ||= self.class.anchors.map { |anchor| "/#{anchor}" }
    end

    def remove_root_section!(path)
      path.sub!(%r(#{$2}/#{$3}/?), '') if path =~ generate_pattern && Site.current.cached_live_sections(:id => $3.to_i, :parent_id => nil).first
    end

    def generate_pattern
      @generate_pattern ||= %r(^(?:/[\w]{2})?(/(#{Section.types.map(&:tableize).join('|')})/([\d]+)(?:/|\.|\?|$)))
    end
  end
end