class GkoCommentsCreateTables < ActiveRecord::Migration
  def up
    unless table_exists?(:comments)
      create_table :comments, :id => true do |t|
        t.references :commentable, :polymorphic => true
        t.boolean :spam
        t.string :name
        t.string :email
        t.text :body
        t.string :state
        t.timestamps
      end

      add_index :comments, :id
      add_index :comments, [:commentable_id, :commentable_type]
    end
  end

  def down
    drop_table :comments if table_exists?(:comments)
  end
end