Rails.application.routes.draw do

  namespace :admin do
    resources :sites do
      resources :testimonial_lists do
        resources :testimonials do
          collection do
            get :move
            get :selected
          end
        end
      end
    end
  end


  get 'testimonial_lists/:testimonial_list_id/categories/:category_id',
      :to => 'testimonials#index',
      :as => :testimonial_list_category
  get 'testimonial_lists/:testimonial_list_id/tags/:sticker_id',
      :to => 'testimonials#index',
      :as => :testimonial_list_sticker
  get 'testimonial_lists/:testimonial_list_id',
      :to => 'testimonials#index',
      :as => :testimonial_list
  get 'testimonial_lists/:testimonial_list_id/*permalink.:format',
      :to => "testimonials#show"
  get 'testimonial_lists/:testimonial_list_id/*permalink',
      :to => "testimonials#show",
      :as => :testimonial_list_testimonial

end


