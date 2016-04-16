# Update crontab with `whenever --update-cron sendCall`
# After that, you can check if the cron has been updated with `crontab -l`

# If you want to stop the cron job, run 'crontab -r'
set :environment, :development
set :output, {:error => 'error.log', :standard => 'cron.log'}



every 1.minutes do
  runner 'DevicesHelper.send_all'
end

every 1.minutes do
  runner 'CompanyHelper.send_report_mail'
end