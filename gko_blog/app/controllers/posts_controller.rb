class PostsController < ContentsController
  respond_to :html, :js, :atom
  belongs_to :blog
  helper :posts
  include Extensions::Controllers::Archivable
end
