Rails.application.routes.draw do
  filter :stickers

  namespace :admin do
    resources :sites do
      resources :sections do
        resources :stickers
      end
    end
  end
end
