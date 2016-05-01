class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :token
      t.datetime :received_at
      t.integer :time_left

      t.timestamps null: false
    end

    add_reference :calls, :worker, index: true, foreign_key: true
  end
end