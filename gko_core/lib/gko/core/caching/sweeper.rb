#http://www.cowboycoded.com/tag/rails3/page/2/ account caching
module Gko
  class Sweeper < ActionController::Caching::Sweeper

    protected

    def site
      Site.current
    end

    def site_locales(site = nil)
      @site_locales ||= site.language_codes
    end

    def expire_site_cache(site)
      expire_site_header(site)
      expire_site_footer(site)
      delete_cached_directories(["#{page_cache_directory}#{site.cache_path}"])
    end

    def expire_section_cache(section)
      delete_cached_section_page(section)
      expire_site_header(section.site)
      expire_site_footer(section.site)
      expire_site_copyright(section.site)
    end

    def expire_content_cache(content)
      delete_cached_content_page(content)
      delete_cached_section_page(content.section)
    end

    def expire_site_header(site)
      site_locales(site).each do |locale|
        expire_fragment("#{site.id.to_s}_#{locale.to_s}_site_header")
      end
    end

    def expire_site_footer(site)
      site_locales(site).each do |locale|
        expire_fragment("#{site.id.to_s}_#{locale.to_s}_site_footer")
      end
    end

    def expire_site_copyright(site)
      site_locales(site).each do |locale|
        expire_fragment("#{site.id.to_s}_#{locale.to_s}_site_copyright")
      end
    end

    # remove index page
    def delete_cached_section_page(section)
      files = []
      directories = []
      section.public_urls.each do |u|
        files << "#{page_cache_directory}#{site.cache_path}#{u}.html"
        files << "#{page_cache_directory}#{site.cache_path}#{u}.html.gz"
        directories << "#{page_cache_directory}#{site.cache_path}#{u}"
      end
      delete_cached_files(files)
      delete_cached_directories(directories)
    end

    # remove show page 
    def delete_cached_content_page(content)
      delete_cached_files(cached_content_pages(content))
    end


    def cached_content_pages(content)
      files = []
      content.public_urls.each do |u|
        files << file_path = "#{page_cache_directory}#{site.cache_path}#{u}.html"
        files << file_path = "#{page_cache_directory}#{site.cache_path}#{u}.html.gz"
      end
      return files
    end

    def delete_cached_directories(directories)
      directories.each do |dir|
        Rails.logger.info "XXXX delete_cached_directories #{dir}"
        dir = Pathname.new(dir) if dir.is_a?(String)
        dir.rmtree if dir.directory?
      end unless directories.empty?
    end

    def delete_cached_files(files)
      files.each do |f|
        f = Pathname.new(f) if f.is_a?(String)
        Rails.logger.info "XXXX delete_cached_files #{f} #{File.exist?(f)}"
        File.delete(f) if File.exist?(f)
      end unless files.empty?
    end
  end
end
