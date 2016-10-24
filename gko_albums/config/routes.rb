Rails.application.routes.draw do

  match 'album_lists/:album_list_id/feed',
        :to => 'albums#index',
        :as => 'album_list_feed',
        :defaults => {:format => "atom"}

  get 'album_lists/:album_list_id/categories/:category_id',
      :to => 'albums#index',
      :as => :album_list_category

  get 'album_lists/:album_list_id/tags/:sticker_id',
      :to => 'albums#index',
      :as => :album_list_sticker

  constraints :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ do
    get 'album_lists/:album_list_id(/:year(/:month(/:day)))',
        :to => 'albums#index', :as => :album_list
  end

  get 'album_lists/:album_list_id/*permalink.:format',
      :to => "albums#show"
  get 'album_lists/:album_list_id/*permalink',
      :to => "albums#show", :as => :album_list_album
      
  namespace :admin do
    resources :sites do
      resources :album_lists do
        resources :albums do
          collection do
            get :selected
          end
        end
      end
    end
  end

end


