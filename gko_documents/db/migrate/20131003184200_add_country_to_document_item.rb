class AddCountryToDocumentItem < ActiveRecord::Migration
  def change
    remove_column :document_items, :country_id if column_exists?(:document_items, :country_id)
    add_column :document_items, :country, :string unless column_exists?(:document_items, :country)
  end
end