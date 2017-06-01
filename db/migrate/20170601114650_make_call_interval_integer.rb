class MakeCallIntervalInteger < ActiveRecord::Migration[5.0]
  def change
    change_column :sites, :call_interval, :integer
  end
end
