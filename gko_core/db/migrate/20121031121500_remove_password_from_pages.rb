class RemovePasswordFromPages < ActiveRecord::Migration
  def up
    remove_column :sections, :password
  end

  def down
    add_column :sections, :password, :string
  end
end