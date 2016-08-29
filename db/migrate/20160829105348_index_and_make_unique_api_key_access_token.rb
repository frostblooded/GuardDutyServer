class IndexAndMakeUniqueApiKeyAccessToken < ActiveRecord::Migration[5.0]
  def change
    add_index :api_keys, :access_token, unique: true
  end
end
