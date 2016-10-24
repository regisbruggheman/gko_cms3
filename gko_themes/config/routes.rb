Rails.application.routes.draw do
    match "/assets/:theme/stylesheets/*asset" => 'themes_for_rails/assets#stylesheets',
          :as => :base_theme_stylesheet, :constraints => {:theme => /[\w\.]*/}
    match "/assets/:theme/javascripts/*asset" => 'themes_for_rails/assets#javascripts',
          :as => :base_theme_javascript, :constraints => {:theme => /[\w\.]*/}
    match "/assets/:theme/images/*asset" => 'themes_for_rails/assets#images',
          :as => :base_theme_image, :constraints => {:theme => /[\w\.]*/}
  get '/theme_preview', :to => 'themes#preview', :as => :theme_preview

  namespace :admin do
    resources :themes do
      resources :theme_assets
      member do
        get :preview
        get :default
        get :load
        get :select
        get :unselect
      end
    end
  end
end