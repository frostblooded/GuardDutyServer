class ChangeActivityCategoryToInteger < ActiveRecord::Migration
  def change
    change_column :activities, :category, :integer
  end
end
