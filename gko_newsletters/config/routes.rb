Rails.application.routes.draw do

  namespace :admin do
    resources :sites do
      resources :newsletter_subscriptions
      resources :newsletter_lists do
        resources :newsletters do
          collection do
            get :selected
          end
        end
      end
    end
  end

  match 'newsletters/subscription',
        :to => 'newsletter_subscriptions#create',
        :method => :post,
        :as => :newsletter_subscription

  match 'newsletter_lists/:newsletter_list_id/feed',
        :to => 'newsletters#index',
        :as => 'newsletter_list_feed',
        :defaults => {:format => "atom"}

  get 'newsletter_lists/:newsletter_list_id/categories/:category_id',
      :to => 'newsletters#index',
      :as => :newsletter_list_category

  get 'newsletter_lists/:newsletter_list_id/tags/:sticker_id',
      :to => 'newsletters#index',
      :as => :newsletter_list_sticker

  constraints :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ do
    get 'newsletter_lists/:newsletter_list_id(/:year(/:month(/:day)))',
        :to => 'newsletters#index', :as => :newsletter_list
  end

  get 'newsletter_lists/:newsletter_list_id/*permalink.:format',
      :to => "newsletters#show"
  get 'newsletter_lists/:newsletter_list_id/*permalink',
      :to => "newsletters#show", :as =>
          :newsletter_list_newsletter

end


