namespace :reports do
  # Technically this task only calls a method, but
  # the scheduler doesn't work if I call the method directly
  desc "send reports to all companies"
  task :send => :environment do
    CompanyHelper.check_mails_status
  end
end
