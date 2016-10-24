class AddLiquidModelsUpdatedAtToSite < ActiveRecord::Migration
  def up
    add_column :sites, :liquid_models_updated_at, :datetime
  end

  def down
    remove_column :sites, :liquid_models_updated_at
  end
end