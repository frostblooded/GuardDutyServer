require 'simplecov'
SimpleCov.start

require 'rails/test_help'
require 'minitest/rails/capybara'

# Make the progress of running tests (rake) a little prettier
require 'minitest/reporters'
Minitest::Reporters.use!

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

class ActiveSupport
  module TestCase
    # Included so that you don't need to add the 'FactoryGirl.' prefix
    # when you use Factory Girl
    include FactoryGirl::Syntax::Methods

    # Setup all fixtures in test/fixtures/*.yml
    # for all tests in alphabetical order
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def request_access_token
      post '/api/v1/access_tokens', name: @company.name,
                                    password: @company.password
      json_response['access_token']
    end

    def json_response
      JSON.parse @response.body
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
  end
end

class ActionController
  module TestCase
    include Devise::Test::ControllerHelpers
  end
end
