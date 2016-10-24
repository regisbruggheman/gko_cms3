class RemoveDelayedModel < ActiveRecord::Migration
  def up
    drop_table :delayed_jobs if table_exists?(:delayed_jobs)
  end

  def down

  end
end