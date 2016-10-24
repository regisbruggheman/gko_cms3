require 'routing_filter'
require 'gko/core/routing_filters/paginate'
require 'gko/core/routing_filters/localize'
require 'gko/core/routing_filters/section_root'
require 'gko/core/routing_filters/section_path'

Rails.application.routes.draw do
  filter :paginate, :section_path, :section_root, :localize # Keep filters order !

  get 'wymiframe(/:id)', :to => 'fast#wymiframe', :as => :wymiframe

  #match "/contact_forms/:id", :to => 'contact_forms#create', :method => :post
  resources :contact_forms, :to => 'contact_forms#create', :only => :create
  get "/sitemap" => 'sitemap#index', :defaults => {:format => 'xml'}
  get "/robots" => 'robots#index', :defaults => {:format => 'txt'}
  post "/pages/:id/connect", :to => 'pages#connect', :as => :page_connect
  get "/pages/:id", :to => 'pages#show', :as => :page

  match "/homes/:id", :to => 'homes#show', :as => :home

  get 'partner_lists/:partner_list_id',
    :to => 'partners#index',
    :as => :partner_list

  get 'faq_pages/:faq_page_id',
    :to => 'faq_elements#index',
    :as => :faq_mosaic

  get 'document_lists/:document_list_id/categories/:category_id',
    :to => 'document_items#index',
    :as => :document_list_category
  get 'document_lists/:document_list_id/tags/:sticker_id',
    :to => 'document_items#index',
    :as => :document_list_sticker
  get 'document_lists/:document_list_id',
    :to => 'document_items#index',
    :as => :document_list
  get 'document_lists/:document_list_id/*permalink.:format',
    :to => "document_items#show"
  get 'document_lists/:document_list_id/*permalink',
    :to => "document_items#show",
    :as => :document_list_document_item

  namespace :admin do
    root :to => 'dashboards#index'

    get :move, :to => 'resources#move', :as => :move
    resources :dialogs, :only => :show
    resources :pages_dialogs, :only => [] do
      collection do
        get :link_to
      end
    end

    resources :image_assignments, :only => [:create, :destroy, :show]
    resources :document_assignments, :only => [:create, :destroy, :show]
    resources :sites do
      resources :assets
      resources :languages
      #resources :liquid_models
      resources :homes, :except => [:show, :index]
      resources :pages, :except => [:show, :index]
      resources :redirects, :except => [:show, :index]
      resources :image_folders do
        collection do
          post :insert
        end
      end
      resources :images do
        member do
          get :download
        end
        collection do
          get :insert
          # Firefox send request with html header if format is not set
          post :batch, :defaults => {:format => 'js'}
          delete :destroy_many
        end
      end
      resources :documents do
        collection do
          get :selected
          get :insert
          # Firefox send request with html header if format is not set
          post :batch, :defaults => {:format => 'js'}
          delete :destroy_many
        end
      end
      resources :document_lists do
        resources :document_items do
          collection do
            get :selected
          end
        end
      end
      resources :partner_lists do
        resources :partners do
          collection do
            get :move
          end
        end
      end

      resources :faq_pages do
        resources :faq_elements do
          collection do
            get :move
          end
        end
      end

      resources :sections, :except => [:show] do
        collection do
          get :selected, :defaults => {:format => 'js'}
          post :restructure, :defaults => {:format => 'js'}
        end
        resources :contents
      end
    end
  end

  root :to => 'homes#show'

end
