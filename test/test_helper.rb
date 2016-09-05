require 'simplecov'
SimpleCov.start

require 'rails/test_help'
require 'minitest/rails/capybara'

# Change the Capybara driver, so JS can be executed
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: true,
                                         phantomjs: Phantomjs.path)
end

# Make the progress of running tests (rake) a little prettier
require 'minitest/reporters'
Minitest::Reporters.use!

# Used so you can sign in during tests
include Warden::Test::Helpers
Warden.test_mode!

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

# Be able to use login_as without locking
# the database
# Disable rubocop checks for this code as it is
# copied from the internet and very important
# rubocop:disable all
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

module ActiveSupport
  class TestCase
    # Included so that you don't need to add the 'FactoryGirl.' prefix
    # when you use Factory Girl
    include FactoryGirl::Syntax::Methods

    # Setup all fixtures in test/fixtures/*.yml
    # for all tests in alphabetical order
    fixtures :all

    # Reset Warden after every test
    def after_teardown
      super
      Warden.test_reset!
      ActionMailer::Base.deliveries = []
    end

    # Add more helper methods to be used by all tests here...
    def request_access_token
      post '/api/v1/access_tokens', params: { name: @company.name,
                                              password: @company.password }
      json_response['access_token']
    end

    def json_response
      ::JSON.parse @response.body
    end

    # Used to create activities easily when you want to set created_at
    def create_activity(category, worker, site, created_at, time_left = 60)
      activity = Activity.create!(category: category,
                                  worker: worker,
                                  site: site,
                                  time_left: time_left)
      activity.update(created_at: created_at, updated_at: created_at)
      activity
    end

    def mail_is_sent?(email)
      mail = ActionMailer::Base.deliveries.first
      !mail.nil? && email == mail['to'].to_s
    end

    def mails_are_sent?(emails)
      return false if ActionMailer::Base.deliveries.nil?

      delivered_to_emails = ActionMailer::Base.deliveries.map do |d|
        d['to'].to_s
      end

      emails.each do |email|
        return false unless delivered_to_emails.include? email
      end

      true
    end

    def reload_page
      visit current_path
    end
  end
end

module ActionController
  class TestCase
    include Devise::Test::ControllerHelpers
  end
end
