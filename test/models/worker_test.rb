require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  def setup
    @worker = Worker.create(name: "Example LName",
    					              password: "Somethinglike",
                            password_confirmation: "Somethinglike")
  end

  test "should be valid" do
    assert @worker.valid?
  end

	test "name should be present" do
  	@worker.name = "   "
  	assert_not @worker.valid?
	end
	
	test "name should not be too long" do
		@worker.name = "a" * 50
		assert_not @worker.valid?
	end

  test "names should be downcase" do
    assert @worker.name == @worker.name.downcase
  end

	test "password should be present" do
		@worker.password = @worker.password_confirmation = " " * 8
		assert_not @worker.valid?
	end

	test "password should have a minimum length" do
		@worker.password = @worker.password_confirmation = "a" * 7
		assert_not @worker.valid?
	end
end
