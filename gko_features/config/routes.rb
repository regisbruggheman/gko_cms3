Rails.application.routes.draw do
  namespace :admin do
    resources :sites do
      resources :features do
        collection do
          get :move
        end
      end
    end
  end
end


