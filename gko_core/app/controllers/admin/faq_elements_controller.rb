class Admin::FaqElementsController < Admin::ContentsController
  nested_belongs_to :site, :faq_page
  respond_to :html, :js
  cache_sweeper FaqElementSweeper, :only => [:create, :update, :destroy]

end