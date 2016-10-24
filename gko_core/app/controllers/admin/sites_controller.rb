class Admin::SitesController < Admin::ResourcesController
  respond_to :html
  cache_sweeper SiteSweeper, :only => [:update, :destroy]

  def begin_of_association_chain;
    nil;
  end

  def index
    if user_master?
      @sites = Site.order('sites.host ASC').all
    end
    respond_with(:admin, @sites)
  end

  def destroy
    if Site.count == 1
      @site.errors[:error] = [:last_site_cant_be_destroyed]
    else
      @site.destroy
    end
    respond_with(:admin, @account, @site)
  end

end
