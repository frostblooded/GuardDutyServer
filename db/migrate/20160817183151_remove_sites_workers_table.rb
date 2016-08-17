class RemoveSitesWorkersTable < ActiveRecord::Migration
  def change
    drop_table :sites_workers
  end
end
