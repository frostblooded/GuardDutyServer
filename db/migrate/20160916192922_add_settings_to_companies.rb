class AddSettingsToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :settings, :text
  end
end
