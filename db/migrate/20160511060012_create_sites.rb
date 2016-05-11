class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name, unique: true

      t.timestamps null: false
    end

    add_reference :sites, :company, index: true, foreign_key: true
  end
end
