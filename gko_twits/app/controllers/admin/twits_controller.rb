class Admin::TwitsController < Admin::ResourcesController
  nested_belongs_to :site, :twit_list
  
  protected

  def collection
    get_collection_ivar || begin
      c = end_of_association_chain
      c = filter_collection(c)
      c = search_all(c) if searching?
      paginate_all(c, paging? ? params[:search][:per_page] : 30)
      set_collection_ivar(c)
    end
  end
end