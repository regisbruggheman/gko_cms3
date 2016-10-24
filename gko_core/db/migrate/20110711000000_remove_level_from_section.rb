class RemoveLevelFromSection < ActiveRecord::Migration
  def up
    remove_column :sections, :level if column_exists?(:sections, :level)
  end

  def down
    add_column :sections, :level, :integer
  end
end
