class AddAccessCountToContents < ActiveRecord::Migration
  def change
    unless column_exists?(:contents, :access_count)
      add_column :contents, :access_count, :integer, :default => 0
      add_index :contents, :access_count
    end
  end
end