require "test_helper"

class CanAccessWorkerIndexTest < Capybara::Rails::TestCase
  def setup
    @company = create(:company)
    @worker = @company.workers.first
    login_as @company
    
    visit workers_path
  end

  test 'shows correct workers' do
    @company.workers.each do |w|
      assert_text w.name
    end

    assert_text 'Create worker'
  end

  test 'worker page link opens worker page' do
    first(:link, @worker.name).click
    assert_equal worker_path(@worker), current_path
  end

  test 'worker edit link opens edit worker page' do
    first(:link, 'edit').click
    assert_equal edit_worker_path(@worker), current_path
  end

  test 'worker delete link deletes worker' do
    first(:link, 'delete').click
    assert_not Worker.exists? @worker.id
  end

  test 'new worker link opens new worker' do
    click_link 'Create worker'
    assert_equal new_worker_path, current_path
  end
end
