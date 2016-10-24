Rails.application.routes.draw do

  namespace :admin do
    resources :sites do
      resources :calendars do
        resources :events do
          collection do
            get :selected
          end
        end
      end
    end
  end
  #TODO Events feed
  #match 'calendars/:calendar_id/feed', :to => 'events#index', :as => 'event_feed', :defaults => {:format => "atom"}
  get 'calendars/:calendar_id/categories/:category_id',
      :to => 'events#index',
      :as => :calendar_category

  get 'calendars/:calendar_id/tags/:sticker_id',
      :to => 'events#index',
      :as => :calendar_sticker

  constraints :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ do
    get 'calendars/:calendar_id(/:year(/:month(/:day)))',
        :to => 'events#index',
        :as => :calendar
  end

  match 'calendars/:calendar_id/*permalink',
        :to => "events#show",
        :as => :calendar_event
end
