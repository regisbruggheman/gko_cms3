Rails.application.routes.draw do
  match 'contact', :to => 'inquiries#new'
  resources :inquiries, :only => [:create]
  namespace :admin do
    resources :sites do
      resources :mail_methods
      resources :inquiries, :only => [:index, :show, :destroy] do
        collection { get :spam }
        member { get :toggle_spam }
      end
    end
  end
end