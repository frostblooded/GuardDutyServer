class RemoveSettingsFromUnusedGem < ActiveRecord::Migration[5.0]
  def change
    drop_table :settings
  end
end
