class RemoveSettingModel < ActiveRecord::Migration
  def up
    drop_table :settings if table_exists?(:settings)
  end

  def down

  end
end