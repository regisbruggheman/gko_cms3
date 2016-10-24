class AddCssToStickers < ActiveRecord::Migration
  def change
    add_column :stickers, :css, :string
  end
end
