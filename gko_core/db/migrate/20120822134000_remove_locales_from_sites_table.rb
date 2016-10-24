class RemoveLocalesFromSitesTable < ActiveRecord::Migration
  def up
    remove_column :sites, :locales if column_exists?(:sites, :locales)
  end

  def down
    add_column :sites, :locales, :string
  end
end