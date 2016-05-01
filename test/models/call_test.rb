require 'test_helper'

class CallTest < ActiveSupport::TestCase
  def setup
    @call = Call.create
  end

  test 'call has token' do
    assert_not @call.token.nil?
  end

  test 'token has valid length' do
    assert_equal 32, @call.token.length
  end
end
