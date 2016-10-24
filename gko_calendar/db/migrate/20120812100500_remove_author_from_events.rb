class RemoveAuthorFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :author_id if column_exists?(:events, :author_id)
  end

  def down
    add_column :events, :author_id, :integer unless column_exists?(:events, :author_id)
  end
end