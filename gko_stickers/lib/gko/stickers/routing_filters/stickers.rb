require 'routing_filter'

module RoutingFilter
  class Stickers < Filter

    def around_recognize(path, env, &block)
      if !excluded?(path)
        sticker_id = extract_sticker_id(env, path)
        yield.tap do |params|
          params[:sticker_id] = sticker_id if sticker_id
        end
      else
        yield
      end
    end

    def around_generate(params, &block)
      yield.tap do |path|
        path = path.to_s
        sticker_id = params.delete('sticker_id') || params.delete(:sticker_id)
        if !excluded?(path) && sticker_id.present?
          sticker = Sticker.translated.find(sticker_id)
          if path =~ section_pattern
            path = "/#{$1}/#{$2}tags/#{sticker.path}"
          elsif sticker.section.live.root?
            path = path.sub!(%r(^/), "tags/#{sticker.path}")
          end
          return path
        end
      end
    end

    protected

    def extract_sticker_id(env, path)
      if section = recognize_section_for(env, path, 'tags') and path =~ recognition_pattern(section)
        Rails.logger.info "XXXXXXXXX recognize_section_for OK"
        if sticker = section.stickers.with_globalize(:path => $2).first
          Rails.logger.info "XXXXXXXXX #{sticker} #{$2} OK"
          path.gsub!("#{$1}#{$2}", '')
          path.replace('/') if path.blank?
          sticker.id.to_s
        end
      end
    end

    def recognition_pattern(section)
      paths = section.stickers.translated.map(&:path).reject(&:blank?)
      paths = paths.sort { |a, b| b.size <=> a.size }.join('|')
      paths.empty? ? %r(^$) : %r(^.*(/tags/)(#{paths})(?=/|\.|\?|$))
    end

  end
end

