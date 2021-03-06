require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GuardDuty
  class Application < Rails::Application
    config.email_regex = /\A\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/
    config.time_regex = /\A([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.available_locales = [:en, :bg]

    # i18n-js requires this
    config.assets.initialize_on_precompile = true

    # Adding 'api' folder to application files for the API
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]

    # Add lib
    config.autoload_paths += %W(#{config.root}/lib)

    # Some common mailer options
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true 
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = {
      :address => "smtp.gmail.com",
      :port => 587,
      :domain => "gmail.com",
      :authentication => 'plain',
      :user_name => ENV["MAIL_SENDER"],
      :password => "@zSumMnogoQk",
      :enable_starttls_auto => true
    }
  end
end
