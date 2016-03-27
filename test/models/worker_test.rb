require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  def setup
    @worker = Worker.new(first_name: "Example FName", last_name: "Example LName",
    					 password: "Somethinglike", password_confirmation: "Somethinglike")
  end

  test "should be valid" do
    assert @worker.valid?
  end

	test "first name should be present" do
  	@worker.first_name = "   "
  	assert_not @worker.valid?
	end

	test "last name should be present" do
  	@worker.last_name = "   "
  	assert_not @worker.valid?
	end	

	test "first name should not be too long" do
		@worker.first_name = "a" * 50
		assert_not @worker.valid?
	end
	
	test "last name should not be too long" do
		@worker.last_name = "a" * 50
		assert_not @worker.valid?
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
