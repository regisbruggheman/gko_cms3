class Admin::LanguagesController < Admin::ResourcesController
  belongs_to :site
  respond_to :html, :js
  cache_sweeper LanguageSweeper, :only => [:create, :update, :destroy]
end
