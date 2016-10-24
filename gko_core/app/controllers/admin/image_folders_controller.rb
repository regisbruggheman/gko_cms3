class Admin::ImageFoldersController < Admin::ResourcesController
  belongs_to :site
  respond_to :js
  before_filter :load_site
  before_filter :load_image_folder, :except => [:index, :new, :create]
  
  def insert
    image_id = params[:image_id].to_i
    render :nothing => true and return if image_id.zero?
    @image = @site.images.find(image_id)
    @image_folder.images << @image
    # FIXME certainly not the best way
    @image.touch
    @image_folder.touch
    render :action => "update"
  end

  def create
    @image_folder = @site.image_folders.create(params[:image_folder])
    render :action => "update"
  end

  def show
    @images = Rails.cache.fetch "admin/image_folders/#{@image_folder.images_timestamp}" do
      @image_folder.images
    end

    show!
  end

  def destroy
    @image_folder.destroy
    respond_with(:admin, @site, @image_folder)
  end

  protected

  def load_image_folder
    @image_folder ||= @site.image_folders.find(params[:id])
  end
end