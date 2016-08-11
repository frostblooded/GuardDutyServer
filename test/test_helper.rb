require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Included so that you don't need to add the 'FactoryGirl.' prefix
  # when you use Factory Girl
  include FactoryGirl::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def request_access_token
    post '/api/v1/access_tokens', {name: @company.name,
                                   password: @company.password}
    json_response['access_token']
  end

  def json_response
    JSON.parse @response.body
  end

  # Used to create activities easily when you want to set created_at
  def create_activity(category, worker, created_at)
    activity = Activity.create(category: category, worker: worker)
    activity.created_at = created_at
    activity
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
