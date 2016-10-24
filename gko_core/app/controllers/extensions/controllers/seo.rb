module Extensions
  module Controllers
    module Seo

      extend ActiveSupport::Concern

      included do # Extend controller
        send :before_filter, :seo_metas, :only => [:index, :show]
      end

      protected

      def seo_metas
        unless request.xhr?
          if site.site_title_on_all_pages
            site_title = site.meta_title.presence ? site.meta_title : site.title
          else
            site_title = nil
          end
          o = action_name == 'index' ? parent : resource
          page_title = o.meta_title.presence ? o.meta_title : o.title
          @meta_title = [page_title, site_title].compact.join(" | ")
          @meta_description = o.meta_description.presence ? o.meta_description : truncate(strip_tags(o.body), :length => 100)
          robot_follow = o.respond_to?(:robot_follow) ? o.robot_follow : false
          robot_index = o.respond_to?(:robot_index) ? o.robot_index : false
          @meta_robots = "#{robot_index ? "" : "no"}index, #{robot_follow ? "" : "no"}follow"
          
          if site.localized? && site.include_alternate_links
            links = []
            site.available_locales.all_codes.reject {|e| current_locale?(e.to_sym)}.each do |locale|
              links << tag( :link, :rel => :alternate, :hreflang => locale.to_s, 
                            :href => [request.protocol, request.host_with_port, o.public_url(locale)].join)
            end
            @alternate_links = links.compact.uniq
          end
        end
      end

    end # Seo
  end # Controllers
end # Extensions
