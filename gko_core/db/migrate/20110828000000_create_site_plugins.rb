class CreateSitePlugins < ActiveRecord::Migration
  def self.up
    add_column :sites, :plugins, :text unless column_exists?(:sites, :plugins)
  end

  def self.down
    remove_column :sites, :plugins
  end
end