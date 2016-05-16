class AddSiteReferenceToDevice < ActiveRecord::Migration
  def change
    add_reference :devices, :site, index: true, foreign_key: true
  end
end
