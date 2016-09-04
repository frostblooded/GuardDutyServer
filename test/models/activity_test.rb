require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  def setup
    @site = create(:site)
    @worker = @site.workers.first
  end

  test 'validates time_left' do
    activity = Activity.new time_left: 'ivan'
    assert_not activity.valid?
  end

  test 'has site' do
    assert_not Activity.new(site: nil, worker: @worker).valid?
  end

  test 'has worker' do
    assert_not Activity.new(site: @site, worker: nil).valid?
  end
end
