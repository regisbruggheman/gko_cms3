# fix-importer-relative-paths
# Fix a "Stack Level Too Deep" Error when compiling
# https://github.com/thoughtbot/bourbon/issues/26
# patch from https://github.com/mjtko/sass-rails/commit/ff40bb7c8e3b7c3ac7d8f5cce232820ffc0fae9b
require 'gem-patching'
require 'sass'
Gem.patching('sass-rails', '3.2.6') do
  
  require 'sass/rails/importer'

  Sass::Rails::Importer.class_eval do

    def resolve(name, base_pathname = nil)
      name = Pathname.new(name)
      if base_pathname && base_pathname.to_s.size > 0
        root = context.pathname.dirname
        name = base_pathname.relative_path_from(root).join(name)
      end
      partial_name = name.dirname.join("_#{name.basename}")
      @resolver.resolve(name) || @resolver.resolve(partial_name)
    end

  end
end