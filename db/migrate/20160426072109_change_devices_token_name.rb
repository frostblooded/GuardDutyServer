class ChangeDevicesTokenName < ActiveRecord::Migration
  def change
    rename_column :devices, :token, :gcm_token
  end
end
