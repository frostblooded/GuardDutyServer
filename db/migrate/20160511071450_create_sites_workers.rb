class CreateSitesWorkers < ActiveRecord::Migration
  def change
    create_table :sites_workers do |t|
      t.integer :site_id
      t.integer :worker_id
    end

    remove_reference :workers, :site, foreign_key: true
  end
end
