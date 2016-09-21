class UseSettingsOnlyForRecipientsInCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :email_time, :string
    add_column :companies, :email_wanted, :boolean
  end
end
