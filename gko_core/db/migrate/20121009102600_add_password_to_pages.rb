class AddPasswordToPages < ActiveRecord::Migration
  def up
    add_column :sections, :password, :string
  end

  def down
    remove_column :sections, :password
  end
end