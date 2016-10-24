class DeleteSupportsTable < ActiveRecord::Migration
  def up
    drop_table :supports if table_exists?(:supports)
  end
end