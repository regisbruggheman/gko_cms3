class Admin::ThemeAssetsController < Admin::ResourcesController

  belongs_to :theme

  respond_to :json, :only => [:index, :create, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @assets = parent.theme_assets.group_by { |a| a.folder.split('/').first.to_sym }
        @js_and_css_assets  = (@assets[:javascripts] || []) + (@assets[:stylesheets] || [])
       # @snippets           = current_site.snippets.order_by([[:name, :asc]]).all.to_a
        render
      }
      format.json {
        render :json => current_site.theme_assets.by_content_type(params[:content_type])
      }
    end
  end

  def edit
    resource = current_site.theme_assets.find(params[:id])
    resource.performing_plain_text = true if resource.stylesheet_or_javascript?
    respond_with resource
  end

end
