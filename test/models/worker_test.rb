require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  def setup
    @company = create(:company)
    @site = @company.sites.first
    @worker = @site.workers.first
  end

  test 'name is present' do
    @worker.name = '   '
    assert_not @worker.valid?
  end

  test 'name is not too long' do
    @worker.name = 'a' * 50
    assert_not @worker.valid?
  end

  test 'names are downcase' do
    assert @worker.name.downcase, @worker.name 
  end

  test 'password is present' do
    @worker.password = @worker.password_confirmation = ' ' * 8
    assert_not @worker.valid?
  end

  test 'password has minimum length' do
    @worker.password = @worker.password_confirmation = 'a' * 7
    assert_not @worker.valid?
  end

  test 'belongs to correct site' do
    assert_equal @site, @worker.sites.first
  end
end
