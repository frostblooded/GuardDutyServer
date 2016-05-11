class AddCompanyReferenceToWorkers < ActiveRecord::Migration
  def change
    add_reference :workers, :company, index: true, foreign_key: true
  end
end
