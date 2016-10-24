class RemoveAccountFromContent < ActiveRecord::Migration
  def up
    remove_column :contents, :account_id if column_exists?(:contents, :account_id)
  end
end