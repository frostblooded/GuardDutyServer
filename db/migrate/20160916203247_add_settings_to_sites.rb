class AddSettingsToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :settings, :text
  end
end
