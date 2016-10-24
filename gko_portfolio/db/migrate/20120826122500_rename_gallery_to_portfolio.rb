class RenameGalleryToPortfolio < ActiveRecord::Migration
  def up
    connection.execute("UPDATE sections SET type='Portfolio' WHERE type='GalleryList'")
    connection.execute("UPDATE contents SET type='Project' WHERE type='Gallery'")
  end
end