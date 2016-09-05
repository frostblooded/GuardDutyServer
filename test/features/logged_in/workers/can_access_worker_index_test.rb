require 'test_helper'

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

  test 'worker delete link deletes worker' do
    first('.worker-delete').click
    assert_not Worker.exists? @worker.id
  end

  test 'has correct links' do
    assert_text @worker.name
    assert has_css?('.worker-edit')
    assert_text 'Create worker'
  end
end
