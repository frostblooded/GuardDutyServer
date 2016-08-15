# Update crontab with `whenever --update-cron sendCall`
# After that, you can check if the cron has been updated with `crontab -l`
# If you want to stop the cron job, run 'crontab -r'

# Include other rails object, so that they can be used to set
# dynamic cronjobs
require File.expand_path('../..//config/environment.rb', __FILE__)

set :environment, :development
set :output, {:error => 'error.log', :standard => 'cron.log'}

Company.all.each do |c|
  email_time = Time.parse c.settings(:mail).time
  email_time = email_time.strftime "%I:%M%P"
  puts email_time

  every 1.day, :at => email_time do
    runner 'c.send_report_mail'
  end
end