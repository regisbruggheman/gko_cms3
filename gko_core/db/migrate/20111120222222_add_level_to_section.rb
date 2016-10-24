class AddLevelToSection < ActiveRecord::Migration
  def up
    unless column_exists?(:sections, :level)
      add_column :sections, :level, :integer
    end
  end

  def down
    if column_exists?(:sections, :level)
      remove_column :sections, :level
    end
  end
end