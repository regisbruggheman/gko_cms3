Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :portfolios do
        resources :projects do
          collection do
            get :move
            get :selected
          end
        end
      end
    end
  end

  get 'portfolios/:portfolio_id/categories/:category_id',
      :to => 'projects#index',
      :as => :portfolio_category

  get 'portfolios/:portfolio_id/tags/:sticker_id',
      :to => 'projects#index',
      :as => :portfolio_sticker

  get 'portfolios/:portfolio_id',
      :to => 'projects#index',
      :as => :portfolio

  get 'portfolios/:portfolio_id/feed',
      :to => 'projects#index',
      :as => 'portfolio_feed',
      :defaults => {:format => "atom"}


  get 'portfolios/:portfolio_id/*permalink.:format',
      :to => "projects#show"
  get 'portfolios/:portfolio_id/*permalink',
      :to => "projects#show", :as => :portfolio_project

end


