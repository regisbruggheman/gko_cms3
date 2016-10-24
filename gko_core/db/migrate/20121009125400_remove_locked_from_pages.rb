class RemoveLockedFromPages < ActiveRecord::Migration
  def up
    remove_column :sections, :locked
    remove_column :sections, :locked_by
  end

  def down
    add_column :sections, :locked, :boolean
    add_column :sections, :locked_by, :integer
  end
end