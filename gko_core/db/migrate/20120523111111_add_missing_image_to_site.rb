class AddMissingImageToSite < ActiveRecord::Migration
  def up
    add_column :sites, :default_image_uid, :string unless column_exists?(:sites, :default_image_uid)
  end

  def down
    remove_column :sites, :default_image_uid
  end
end