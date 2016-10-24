Rails.application.routes.draw do

  constraints :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ do
    get 'twit_lists/:twit_list_id(/:year(/:month(/:day)))',
        :to => 'twits#index',
        :as => :twit_list
  end

  constraints :permalink => %r(\d{4}/\d{1,2}/\d{1,2}/[\w-]+) do
    get 'twits/:twit_list_id/*permalink.:format', :to => "twits#show"
    get 'twits/:twit_list_id/*permalink', :to => "twits#show", :as => :twit_list_twit
  end

  resources :twit_lists do
    resources :twits
  end

  namespace :admin do
    resources :sites do
      resources :twit_lists do
        resources :twits
      end
    end
  end

end