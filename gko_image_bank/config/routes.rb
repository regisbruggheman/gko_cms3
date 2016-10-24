Rails.application.routes.draw do
  
  get 'image_banks/:image_bank_id/categories/:category_id',
      :to => 'image_bank_photos#index',
      :as => :image_bank_category
      
  get 'image_banks/:image_bank_id',
      :to => 'image_bank_photos#index',
      :as => :image_bank

  namespace :admin do
    resources :sites do
      resources :image_banks do
        resources :image_bank_photos
      end
    end
  end

end