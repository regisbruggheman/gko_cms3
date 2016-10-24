class Admin::StickersController < Admin::ResourcesController
  nested_belongs_to :site, :section
  cache_sweeper StickerSweeper, :only => [:create, :update, :destroy]
  
  protected

  def collection
    get_collection_ivar || begin
      c = end_of_association_chain
      c = filter_collection(c)
      c = search_all(c) if searching?
      
      #order_attribute = if ordering?
      #  params[:search][:order] 
      #elsif parent.respond_to?(:default_order) && parent.default_order.presence
      #  parent.default_order
      #end
        
      #c = order_all(c, order_attribute) if order_attribute 
      
      #if parent.respond_to?(:default_order) && parent.default_order.presence != "position"
      #  c = paginate_all(c, paging? ? params[:search][:per_page] : 30)
      #end
      
      set_collection_ivar(c)
    end
  end
end
