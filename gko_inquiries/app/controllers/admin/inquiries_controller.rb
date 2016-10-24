class Admin::InquiriesController < Admin::ResourcesController
  belongs_to :site
  respond_to :html, :js
  has_scope :with_email, :only => :index
  has_scope :with_name, :only => :index
  
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
      
      c = paginate_all(c, 30)

      set_collection_ivar(c)
    end
  end
  
  def spam
    @inquiries = site.inquiries.spam
    render :action => 'index'
  end

  def toggle_spam
    @inquiry = site.inquiries.find_by_id(params[:id])
    @inquiry.toggle!(:spam)
    redirect_to :back
  end

end
