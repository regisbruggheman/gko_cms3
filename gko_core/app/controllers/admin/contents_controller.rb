class Admin::ContentsController < Admin::ResourcesController
  include Extensions::Controllers::Cacheable
  has_scope :with_title, :only => :index
  has_scope :with_query, :only => :index
  respond_to :html, :js
  custom_actions :collection => [:selected]
  cache_sweeper ContentSweeper, :only => [:create, :update, :destroy]

end
