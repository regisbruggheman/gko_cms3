class PagesController < BaseController

  include Extensions::Controllers::Seo

  after_filter { |c| c.write_cache? }

  def show
    #Rails.logger.info("XXXXXXXXXX etag #{response.etag}------ last_modified #{response.last_modified}")
    if !site.public || resource.restricted? || Rails.env.development?
      respond_with( resource, :template => template? )
    elsif stale?( :etag => ["page", I18n.locale, site, resource], :last_modified => site.updated_at.utc, :public => true )
      respond_with( resource, :template => template? )
    end
  end


  def connect
    authenticate_user!
    if user_signed_in?
      respond_to do |format|
        format.html {
          flash.notice = t(:logged_in_succesfully)
          render :show
        }
      end
    else
      flash[:failure] = I18n.t("devise.failure.invalid")
      redirect_to :back
    end
  end

  def images
    respond_with(resource.images, :template => '')
  end

  protected

  def resource(fallback_to_404 = true)
    get_resource_ivar || set_resource_ivar(end_of_association_chain.live.find(params[:id]))
    @section = get_resource_ivar || (error_404 if fallback_to_404)
  end

  def template?
    if resource.restricted? and !user_signed_in?
      @restricted_page_title = resource.title
      session["user_return_to"] = request.fullpath
      "pages/login"
    elsif resource.template.present?
      "pages/#{resource.template}"
    else
      "pages/show"
    end
  end

  def layout?
    if resource.layout.present? && params[:format] == 'html'
      resource.layout
    else
      super
    end
  end

  def cache_url
    resource.public_url
  end

end
