class RemoveAccountFromDocument < ActiveRecord::Migration
  def up
    remove_column :documents, :account_id if column_exists?(:documents, :account_id)
  end
end