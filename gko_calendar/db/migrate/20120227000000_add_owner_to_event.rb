class AddOwnerToEvent < ActiveRecord::Migration
  def self.up
    unless column_exists?(:events, :owner_type)
      add_column :events, :owner_type, :string
      add_column :events, :owner_id, :integer
      add_index :events, [:owner_type, :owner_id]
    end
  end

  def self.down
    if column_exists?(:events, :owner_type)
      remove_index :events, [:owner_type, :owner_id]
      remove_column :events, :owner_id
      remove_column :events, :owner_type
    end
  end
end