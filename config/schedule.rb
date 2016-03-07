# Update crontab with `whenever --update-cron sendCall`
# After that, you can check if the cron has been updated with `crontab -l`
set :environment, :production
set :output, {:error => 'error.log', :standard => 'cron.log'}

every 1.minutes do
  rake "call:send"
end