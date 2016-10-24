require 'inherited_resources'
require 'has_scope'
class BaseController < InheritedResources::Base

  include Extensions::Controllers::Base

  # Need by strip_tags method
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper
  include Extensions::Controllers::Localize

  before_filter { body_id if request.format == :html }

  @@site_resolver = {}

  respond_to :html, :js
  helper :base, :minimal, :cache, :images, :bootstrap, :devices
  layout :layout?
  
  class_attribute :includes
  self.includes = []
  
  # FIXME patch for 404 in frontend
  def error_404(exception=nil)
    @meta_title = "The page you were looking for doesn't exist (404)"
    render :template => '/errors/404', :formats => [:html], :status => 404
    return false
  end
  
  protected

  def begin_of_association_chain
    site
  end

  def layout?
    case params[:format]
    when 'atom' then
      false
      else # html - when xhr resquest.format is nil not html
        if request.xhr?
          false
        else
          site.preferred_public_layout.present? ? site.preferred_public_layout : "application"
        end
      end
    end

  # FIXME Should be an helper
  def body_id
    @body_id = (action_name == 'index') ? resource_collection_name : resource_instance_name
  end
  
  # FIXME Already in section extension ?
  def per_page
    @per_page ||= (params[:per_page] || parent.contents_per_page)
  end

  # Save whole Page after delivery
  def write_cache?
    if site.front_page_cached and c = cache_url
      #Rails.logger.info("request.path:::: #{request.path}")
      cache_page(response.body, File.join(site.cache_path, c).to_s)
    end
  end

  def cache_url
    request.path.sub("//", "/")
  end

end