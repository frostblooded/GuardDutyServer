# Update crontab with `whenever --update-cron check_report_emails`
# After that, you can check if the cron has been updated with `crontab -l`
# If you want to stop the cron job, run 'crontab -r'

set :output, { error: 'error.log', standard: 'cron.log' }

every 10.minutes do
  rake 'reports:send'
end
