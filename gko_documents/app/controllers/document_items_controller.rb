class DocumentItemsController < BaseController
  include Extensions::Controllers::BelongsToSection
  actions :index
  respond_to :html
  belongs_to :document_list

  protected
  
  def collection
    unless get_collection_ivar 
      order = 'document_items.title'
      order = 'document_items.published_at DESC' if parent.use_publication_date
      set_collection_ivar(end_of_association_chain.order(order))
    end
    get_collection_ivar
  end 
end