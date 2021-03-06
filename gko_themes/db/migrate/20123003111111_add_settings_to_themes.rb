class AddSettingsToThemes < ActiveRecord::Migration
  def up
    add_column :themes, :settings, :text unless column_exists?(:themes, :settings)
  end

  def down
    remove_column :themes, :settings if column_exists?(:themes, :settings)
  end
end  
                