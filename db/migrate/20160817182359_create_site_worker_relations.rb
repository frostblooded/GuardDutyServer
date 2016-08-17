class CreateSiteWorkerRelations < ActiveRecord::Migration
  def change
    create_table :site_worker_relations do |t|
      t.timestamps null: false
    end

    add_reference :site_worker_relations, :site
    add_reference :site_worker_relations, :worker
  end
end
