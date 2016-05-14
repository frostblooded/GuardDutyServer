# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

  config.action_mailer.default_url_options = {:host => 'hidden-shelf-43728.herokuapp.com', :protocol => 'http'} #I've also tried it without ":protocol => 'http'"
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true 
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
  :user_name => 'app49921759@heroku.com',
  :password => '8TrSnysfTfp1',
  :domain => 'hidden-shelf-43728.herokuapp.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
