class Admin::ResourcesController < Admin::BaseController
  authorize_resource
  skip_authorize_resource :only => :move #TODO why cancan does not work ?
  helper_method :searching?
  
  def resources_controller?
    true
  end

  # Overwritte inherited create method to redirect to edit method after the creation
  # POST /resources
  def create(options={}, &block)
    object = build_resource

    if create_resource(object)
      #FIXME asset_assignment do not have edit method so generation of edit_utl failed
      unless options[:location].present?
        if respond_to?(:edit)
          options[:location] = edit_resource_url(:cl => @resource_locale) rescue nil
        end
      end
    end
    respond_with_dual_blocks(object, options, &block)
    
    #create!{edit_resource_url(:cl => @resource_locale)}
  end

  alias :create! :create

  # Overwritte inherited update method to redirect to edit method after the creation
  # PUT /resources/1 
  def update(options={}, &block)
    object = resource

    if update_resource(object, resource_params)
      options[:location] ||= edit_resource_url(:cl => @resource_locale)
    end

    respond_with_dual_blocks(object, options, &block)
  end

  alias :update! :update

  def destroy
    destroy! do |success, failure|
      success.html do
        redirect_to collection_url(:cl => @resource_locale) and return
      end
    end
  end

  
  def move
    if params[:position].present? && params[:id].present? && params[:model_name].present?
      o = params[:model_name].constantize.find(params[:id])
      o.insert_at(params[:position].to_i)
      render(:head => 200)
    else
      puts "something wrong"
    end
  end

  def resource
    get_resource_ivar || begin
      if params.has_key?(:id)
        set_resource_ivar(end_of_association_chain.send(method_for_find, params[:id]))
      else
        build_resource
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

      if parent.respond_to?(:default_order) && parent.default_order.presence != "position"
        c = paginate_all(c, paging? ? params[:search][:per_page] : 30)
      end
      
      set_collection_ivar(c)
    end
  end

  def filter_collection(col)
    return col
  end

  def search_all(col)
    apply_scopes(col, params[:search])
  end

  def order_all(col, order)
    col.order("#{resource_class.base_class.name.tableize}.#{order}")
  end

  def paginate_all(col, per_page)
    col.paginate(:page => params[:page], :per_page => per_page)
  end

  def paging?
    @paging ||= searching? && params[:search].has_key?(:per_page)
  end

  def ordering?
    @ordering ||= searching? && params[:search].has_key?(:order)
  end

  def searching?
    @searching ||= params.has_key?(:search)
  end

  def get_unstranstaled_resources
    @untranstaled_resources_count ||= begin
      end_of_association_chain.count - end_of_association_chain.with_translations({:locale => "en"}).count
    end unless !current_site.localized? or resource.class.required_translated_attributes.empty?
  end

  #TODO : test group_by_date
  def group_by_date(records)
    new_records = []

    records.each do |record|
      key = record.created_at.strftime("%Y-%m-%d")
      record_group = new_records.collect { |records| records.last if records.first == key }.flatten.compact << record
      (new_records.delete_if { |i| i.first == key }) << [key, record_group]
    end

    new_records
  end

  private
  # URL to redirect to when redirect implies resource url.
  def smart_resource_url
    url = nil
    if respond_to? :edit
      url = edit_resource_url rescue nil
    else
      url = resource_url rescue nil
    end
    url ||= smart_collection_url
  end
  
  def load_site
    @site = Site.find(params[:site_id])
  end

end
