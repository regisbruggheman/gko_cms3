class Admin::DocumentAssignmentsController < Admin::ResourcesController
  respond_to :html, :js
  cache_sweeper DocumentAssignmentSweeper, :only => [:create, :move, :destroy]
end