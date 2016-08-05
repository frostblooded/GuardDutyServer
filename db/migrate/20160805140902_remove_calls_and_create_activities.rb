class RemoveCallsAndCreateActivities < ActiveRecord::Migration
  def change
  	drop_table :calls

  	create_table :activities do |t|
  		t.string :category
      t.integer :time_left
      t.belongs_to :worker

      t.timestamps null: false
  	end
  end
end
