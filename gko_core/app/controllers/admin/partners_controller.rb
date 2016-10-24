class Admin::PartnersController < Admin::ResourcesController
  belongs_to :site
  belongs_to :partner_list
  respond_to :html, :js
  cache_sweeper PartnerSweeper, :only => [:create, :update, :destroy]

end