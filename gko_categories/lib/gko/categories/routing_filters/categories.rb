require 'routing_filter'

module RoutingFilter
  class Categories < Filter

    def around_recognize(path, env, &block)
      if !excluded?(path)
        category_id = extract_category_id(env, path)
        yield.tap do |params|
          params[:category_id] = category_id if category_id
        end
      else
        yield
      end
    end

    def around_generate(params, &block)
      yield.tap do |path|
        path = path.to_s
        category_id = params.delete('category_id') || params.delete(:category_id)
        if !excluded?(path) && category_id.present?
          category = Category.translated.find(category_id)
          if path =~ section_pattern
            path = "/#{$1}/#{$2}categories/#{category.path}"
          elsif category.section.root?
            path = path.sub!(%r(^/), "categories/#{category.path}")
          end
          return path
        end
      end
    end

    protected

    def extract_category_id(env, path)
      if section = recognize_section_for(env, path, 'categories') and path =~ recognition_pattern(section)
        if category = section.categories.with_globalize(:path => $2).first
          path.gsub!("#{$1}#{$2}", '')
          path.replace('/') if path.blank?
          category.id.to_s
        end
      end
    end

    def recognition_pattern(section)
      paths = section.categories.translated.map(&:path).reject(&:blank?)
      paths = paths.sort { |a, b| b.size <=> a.size }.join('|')
      paths.empty? ? %r(^$) : %r(^.*(/categories/)(#{paths})(?=/|\.|\?|$))
    end

  end
end

