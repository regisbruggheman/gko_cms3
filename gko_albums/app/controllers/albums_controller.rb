class AlbumsController < ContentsController
  belongs_to :album_list
  
  protected

  #def paginate_all(collection)
  #  num_page = params[:page] || 1
  #  Rails.cache.fetch("#{I18n.locale.to_s}/#{num_page}/#{parent.albums_cached_key}") do
  #    collection.paginate(:page => params[:page] || 1, :per_page => parent.contents_per_page).all
  #  end
  #end
end