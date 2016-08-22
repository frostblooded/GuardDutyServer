# Has some application-wide settings for the mailer
class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAIL_SENDER"]
  layout 'mailer'
end
