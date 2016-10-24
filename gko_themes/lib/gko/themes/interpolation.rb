# encoding: utf-8
module Gko
  module Themes

    module Interpolation

      def interpolate(pattern, name = nil)
        pattern.gsub(":root", Gko::Themes.config.base_dir.to_s).gsub(":name", name.to_s)
      end

    end
  end
end