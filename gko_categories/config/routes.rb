Rails.application.routes.draw do
  filter :categories

  namespace :admin do
    resources :sites do
      resources :sections do
        resources :categories do
          collection do
            get :selected
            post :restructure, :defaults => {:format => 'js'}
          end
        end
      end
    end
  end
end
