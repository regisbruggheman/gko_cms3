class Admin::ImageAssignmentsController < Admin::ResourcesController
  respond_to :html, :js
  cache_sweeper ImageAssignmentSweeper, :only => [:create, :move, :destroy]

end