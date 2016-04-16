class CreateCompanySettings < ActiveRecord::Migration
  def change
    create_table :company_settings do |t|

      t.timestamps null: false
    end
  end
end
