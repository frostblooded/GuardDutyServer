class RemoteTokenAndReceivedAtFromCalls < ActiveRecord::Migration
  def change
  	remove_column :calls, :token
  	remove_column :calls, :received_at
  end
end
