Rails.application.routes.draw do
  devise_for :user,
    :controllers => {:sessions => 'user_sessions',
                     :registrations => 'user_registrations',
                     :passwords => "user_passwords"},
    :skip => [:unlocks, :omniauth_callbacks],
    :path_names => {:sign_out => 'logout'}

  resources :users, :only => [:edit, :update]

  devise_scope :user do
    get "/login" => "user_sessions#new", :as => :login
    get "/logout" => "user_sessions#destroy", :as => :logout
    get "/signup" => "user_registrations#new", :as => :signup
  end

  namespace :admin do
    resources :sites do
      resources :users do
        member do
          get :change_password
          put :update_password
        end
      end
    end
  end
end
