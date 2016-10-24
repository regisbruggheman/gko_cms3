Rails.application.routes.draw do

  
  match '/hotel_booking', :to => 'hotel_inquiries#new'

  resources :hotel_inquiries, :only => [:create] do
    collection do
      get :thank_you
    end
  end

  match '/table_booking', :to => 'table_inquiries#new'

  resources :table_inquiries, :only => [:create] do
    collection do
      get :thank_you
    end
  end

end
