class RenameSitesWorkers < ActiveRecord::Migration[5.0]
  def change
    rename_table :site_worker_relations, :sites_workers
  end
end
