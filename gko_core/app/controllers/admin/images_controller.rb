class Admin::ImagesController < Admin::ResourcesController
  has_scope :with_query, :with_size_over,
            :with_size_under, :with_width_over, :with_width_under,
            :with_height_over, :with_height_under, :only => [:index, :insert]
  has_scope :unused, :type => :boolean, :only => [:index, :insert]
  custom_actions :collection => :insert
  custom_actions :resource => :batch
  belongs_to :site
  respond_to :html, :js, :json
  before_filter :load_attachable, :only => [:new, :insert, :batch]
  before_filter :set_insert, :only => [:insert]
  before_filter :load_folders, :only => [:destroy]
  caches_action :index, 
                :cache_path => :index_cache_path.to_proc, 
                :if => :cache_action_index?


  #def download
    # FIXME does not work :: Empty File
  #  @image = current_site.images.find(params[:id])
    # Image magick seems to need a absolute path
  #  media = ::Dragonfly[:images].datastore.url_for(@image.uid)
  #  send_file(File.join(Rails.root, 'public', media),
 #             :filename => resource.name,
 #             :type => resource.mime_type,
 #             :disposition => 'attachment')
 # end

  # sends file inline. i.e. for viewing pdfs/movies in browser
 # def show
 #   @image = Attachment.find(params[:id])
 #   send_file(
 #     @image.public_filename,
 #     {
 #       :name => @attachment.filename,
 #       :type => @attachment.content_type,
 #       :disposition => 'inline'
 #     }
 #   )
 # end

  
  # TODO: Callback with error if any?
  def batch
    @image = current_site.images.new(
        :image => params[:file],
        :image_folder_ids => params[:image][:image_folder_ids]
    )

    respond_to do |format|
      if @image.save
        if @attachable
          @image_assignment = @attachable.image_assignments.create!({:image => @image})
        end
        flash[:success] = "Image successfully created"
        format.js do
          render("admin/images/batch", :layout => false, :status => :created) and return
        end
      else
        format.js do
          render :json => @image.errors, :status => :unprocessable_entity
        end
      end
    end
  end

  protected

  def collection
    get_collection_ivar || begin
      c = end_of_association_chain
      c = filter_collection(c)
      c = search_all(c) if searching?
      
      order_attribute = if ordering?
        params[:search][:order] 
      elsif parent.respond_to?(:default_order) && parent.default_order.presence
        parent.default_order
      end
        
      c = order_all(c, order_attribute) if order_attribute 
      c = paginate_all(c, paging? ? params[:search][:per_page] : 30)
      
      set_collection_ivar(c)
    end
  end

  # Get the cache path for the index action including all parameters
  def index_cache_path
    images_timestamp = "#{site.images.maximum(:updated_at)}.try(:to_i)-#{site.images.count}"
    folders_timestamp = "#{site.image_folders.maximum(:updated_at)}.try(:to_i)-#{site.image_folders.count}"
    timestamp = "admin-images-" + @resource_locale.to_s + "/" + images_timestamp + "/" + folders_timestamp + "/" + params.inspect
    {:tag => Digest::MD5.hexdigest(timestamp)}
  end

  # Check if index action is cached.
  # Do not cache json/js format else DOM is not modified by partial
  def cache_action_index?
    site.admin_cache_enabled && !(request.format.json? || request.format.js?)
  end
  
  def set_insert
    params[:insert] = true
  end

  def filter_collection(col)
    if @attachable && @attachable.images.any?
      ids = @attachable.images.map(&:id)
      col = col.where("images.id NOT in (?)", ids)
    end
    return col.order('images.created_at DESC')
  end

  private

  def load_attachable
    if params[:attachable_id].present? && params[:attachable_type].present?
      @attachable = params[:attachable_type].camelize.constantize.find(params[:attachable_id])
    end
  end

  def load_folders
    @image_folders = resource.image_folders.all
    @image_folders
  end

end