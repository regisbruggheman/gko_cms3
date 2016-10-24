class GkoTwitsCreateTables < ActiveRecord::Migration
  def up
    unless table_exists?(:twits)
      create_table :twits do |t|
        t.references :account
        t.references :author
        t.references :section
        t.references :site
        t.string :body
        t.date :published_at
        t.date :expire_at
        t.timestamps
      end
    end
  end

  def down
    drop_table :twits
  end
end