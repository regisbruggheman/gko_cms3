Rails.application.routes.draw do

  namespace :admin do
    resources :sites do
      resources :service_lists do
        resources :services do
          collection do
            get :move
            get :selected
          end
        end
      end
    end
  end


  get 'service_lists/:service_list_id/categories/:category_id',
      :to => 'services#index',
      :as => :service_list_category
  get 'service_lists/:service_list_id/tags/:sticker_id',
      :to => 'services#index',
      :as => :service_list_sticker
  get 'service_lists/:service_list_id',
      :to => 'services#index',
      :as => :service_list
  get 'service_lists/:service_list_id/*permalink.:format',
      :to => "services#show"
  get 'service_lists/:service_list_id/*permalink',
      :to => "services#show",
      :as => :service_list_service

end


