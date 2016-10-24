class Admin::PostsController < Admin::ContentsController
  nested_belongs_to :site, :blog
end