class ChangeCompanyAndWorkerReferences < ActiveRecord::Migration
  def change
    add_reference :workers, :site, index: true, foreign_key: true
    remove_reference :workers, :company, index: true
  end
end
