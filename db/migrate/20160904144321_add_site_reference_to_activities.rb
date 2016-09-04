class AddSiteReferenceToActivities < ActiveRecord::Migration[5.0]
  def change
    add_reference :activities, :site
  end
end
