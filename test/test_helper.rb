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
    json = JSON.parse @response.body
    json['access_token']
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
