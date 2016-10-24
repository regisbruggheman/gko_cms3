class RemoveLevelFromCategories < ActiveRecord::Migration
  def up
    remove_column :categories, :level if column_exists?(:categories, :level)
  end
end