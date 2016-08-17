class RemoveUnnecessaryIndex < ActiveRecord::Migration
  def change
    remove_index(:companies, :name => "index_companies_on_email")
  end
end
