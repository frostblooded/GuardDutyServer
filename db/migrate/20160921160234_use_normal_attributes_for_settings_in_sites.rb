class UseNormalAttributesForSettingsInSites < ActiveRecord::Migration[5.0]
  def change
    remove_column :sites, :settings
    add_column :sites, :call_interval, :string
    add_column :sites, :shift_start, :string
    add_column :sites, :shift_end, :string
  end
end
