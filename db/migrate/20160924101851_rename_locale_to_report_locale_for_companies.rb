class RenameLocaleToReportLocaleForCompanies < ActiveRecord::Migration[5.0]
  def change
    rename_column :companies, :locale, :report_locale
  end
end
