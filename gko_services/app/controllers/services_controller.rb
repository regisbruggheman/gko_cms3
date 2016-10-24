class ServicesController < ContentsController
  respond_to :html
  belongs_to :service_list

  protected

  def filter_collection(collection)
    if params[:category_id].present?
      @category = Category.find(params[:category_id])
      category_ids = category.self_and_descendants.map(&:id)
      collection = collection.published.categorized(category_ids)
    end

    if params[:sticker_id].present?
      @sticker = Sticker.find(params[:sticker_id])
      collection = collection.published.sticked(@sticker.name)
    end

    return collection
  end
end