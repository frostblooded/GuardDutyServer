class AddExpirationDateToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :expires_on, :datetime
  end
end
