class AddIndexCompanyNameToCompanies < ActiveRecord::Migration
  def change
  	add_index :companies, :company_name, unique: true
  end
end
