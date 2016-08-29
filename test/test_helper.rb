require 'simplecov'
SimpleCov.start

require 'rails/test_help'
require 'minitest/rails/capybara'

# Make the progress of running tests (rake) a little prettier
require 'minitest/reporters'
Minitest::Reporters.use!

# Used so you can sign in during tests
include Warden::Test::Helpers
Warden.test_mode!

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

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
    def create_activity(category, worker, created_at, time_left = 60)
      activity = Activity.create(category: category,
                                 worker: worker,
                                 time_left: time_left)
      activity.created_at = created_at
      activity.save
      activity
    end

    def mail_is_sent?(company)
      mail = ActionMailer::Base.deliveries.last
      !mail.nil? && company.email == mail['to'].to_s
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
