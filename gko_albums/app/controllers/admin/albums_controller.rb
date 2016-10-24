class Admin::AlbumsController < Admin::ContentsController
  nested_belongs_to :site, :album_list
end