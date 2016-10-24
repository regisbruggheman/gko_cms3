Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :analytics, :only => :index
    end
  end
end