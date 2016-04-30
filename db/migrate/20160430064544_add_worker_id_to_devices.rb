class AddWorkerIdToDevices < ActiveRecord::Migration
  def change
    add_reference :devices, :worker, index: true, foreign_key: true
  end
end
