Rails.application.routes.draw do
  match 'blogs/:blog_id/feed',
        :to => 'posts#index',
        :as => 'blog_feed',
        :defaults => {:format => "atom"}

  get 'blogs/:blog_id/categories/:category_id',
      :to => 'posts#index',
      :as => :blog_category

  get 'blogs/:blog_id/tags/:sticker_id',
      :to => 'posts#index',
      :as => :blog_sticker

  constraints :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ do
    get 'blogs/:blog_id/(/:year(/:month(/:day)))', :to => 'posts#index', :as => :blog
  end

  constraints :permalink => %r(\d{4}/\d{1,2}/\d{1,2}/[\w-]+) do
    get 'blogs/:blog_id/*permalink.:format', :to => "posts#show"
    get 'blogs/:blog_id/*permalink', :to => "posts#show", :as => :blog_post
  end
  namespace :admin do
    resources :sites do
      resources :blogs do
        resources :posts do
          collection do
            get :selected
          end
        end
      end
    end
  end
end
  