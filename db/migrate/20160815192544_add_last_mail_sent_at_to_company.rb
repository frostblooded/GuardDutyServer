class AddLastMailSentAtToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :last_mail_sent_at, :datetime
  end
end
