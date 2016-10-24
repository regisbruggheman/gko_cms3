class AddTwitTranslations < ActiveRecord::Migration
  def self.up
    Twit.create_translation_table! :body => :text unless table_exists?(:twit_translations)
  end

  def self.down
    Twit.drop_translation_table
  end
end