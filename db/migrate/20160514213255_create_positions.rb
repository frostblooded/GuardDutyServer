class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.float :latitude
      t.float :longitude
      t.integer :index

      t.timestamps null: false
    end

    add_reference :positions, :route, index: true, foreign_key: true
  end
end
