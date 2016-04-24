class RemoveExpirationDateFromApiKeys < ActiveRecord::Migration
  def change
    remove_column :api_keys, :expires_on
  end
end
