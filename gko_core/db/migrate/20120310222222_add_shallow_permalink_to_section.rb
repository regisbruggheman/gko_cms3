class AddShallowPermalinkToSection < ActiveRecord::Migration
  def change
    add_column :sections, :shallow_permalink, :boolean, :default => true unless column_exists?(:sections, :shallow_permalink)
  end
end