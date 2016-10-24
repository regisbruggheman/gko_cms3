class RemoveSiteRegistrationsCountFromSite < ActiveRecord::Migration
  def up
    remove_column :sites, :site_registrations_count if column_exists?(:sites, :site_registrations_count)
  end
end 