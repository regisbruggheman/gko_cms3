class AddTemplateToSection < ActiveRecord::Migration
  def up
    add_column :sections, :template, :string unless column_exists?(:sections, :template)
    Section.reset_column_information
    Section.all.each do |s|
      s.update_column(:template, s.layout)
      s.update_column(:layout, nil)
    end
  end

  def down
    remove_column :sections, :template if column_exists?(:sections, :template)
  end
end