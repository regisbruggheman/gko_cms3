class AddVideoToImage < ActiveRecord::Migration
  def change
    add_column :images, :video_url, :string
  end
end