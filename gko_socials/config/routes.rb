Rails.application.routes.draw do
  devise_for :users,
             :class_name => User,
             :skip => [:unlocks],
             :controllers => { :sessions => 'user_sessions', :omniauth_callbacks => "omniauth_callbacks", :registrations => 'user_registrations' }
  resources :user_authentications

  match 'account' => 'users#show', :as => 'user_root'

  namespace :admin do
    resources :authentication_methods
  end

end
