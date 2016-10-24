class RemoveAccountFromTwit < ActiveRecord::Migration
  def up
    remove_column :twits, :account_id if column_exists?(:twits, :account_id)
  end
end