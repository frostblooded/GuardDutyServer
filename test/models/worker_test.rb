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

  test 'name is unique in company' do
    @other_company = create(:company)
    @worker1 = Worker.new name: @worker.name,
                          password: 'foobarrr',
                          company: @company
    assert_not @worker1.valid?

    @worker2 = Worker.new name: @worker.name,
                          password: 'foobarrr',
                          company: @other_company
    assert @worker2.valid?
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
