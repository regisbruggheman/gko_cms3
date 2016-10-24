class Admin::CommentsController < Admin::BaseController
  belongs_to :site
  belongs_to :section
end
