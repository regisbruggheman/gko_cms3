class Admin::ProjectsController < Admin::ContentsController
  nested_belongs_to :site, :portfolio 
  before_filter :init_associations, :only => [:new, :edit]
  
  protected
  
  def init_associations
    #resource.build_video if resource.video.nil?
  end
  
  def collection
    get_collection_ivar || begin
      c = end_of_association_chain
      c = filter_collection(c)
      c = search_all(c) if searching?
      c = order_all(c, "position") 
      set_collection_ivar(c)
    end
  end
end