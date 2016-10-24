class AddCustomStyleToSite < ActiveRecord::Migration
  def up
    add_column :sites, :stylesheet, :text
    add_column :sites, :javascript, :text
  end

  def down
    remove_column :sites, :stylesheet 
    remove_column :sites, :javascript
  end
end                                                            