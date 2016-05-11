class ChangeWorkersNameFormat < ActiveRecord::Migration
  def change
    remove_column :workers, :first_name
    remove_column :workers, :last_name
    add_column :workers, :name, :string
  end
end
