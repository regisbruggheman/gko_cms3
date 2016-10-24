class AddRestrictedToPages < ActiveRecord::Migration
  def up
    add_column :sections, :restricted, :boolean, :default => false
  end

  def down
    remove_column :sections, :restricted
  end
end