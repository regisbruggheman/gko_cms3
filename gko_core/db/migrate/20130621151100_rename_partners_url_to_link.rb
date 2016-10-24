class RenamePartnersUrlToLink < ActiveRecord::Migration
  def change
    rename_column :partners, :url, :link if column_exists?(:partners, :url)
  end
end