class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token, unique: true
      t.references :company_id

      t.timestamps null: false
    end
  end
end
