class HomesController < PagesController

  def show
    show!(:template => resource.layout.present? ? "pages/#{resource.layout}" : "pages/home")
  end

  def resource
    get_resource_ivar || set_resource_ivar(site.home)
  end

  protected

  def body_id
    @body_id = "home"
  end

  def write_cache?
    false#site.preferred_homepage_cache_enabled
  end

end