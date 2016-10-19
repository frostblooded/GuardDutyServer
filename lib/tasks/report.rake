namespace :reports do
  desc "send reports to all companies"
  task :send => :environment do
    CompanyHelper.check_mails_status
  end
end
