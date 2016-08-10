require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
	def setup
		@company = create(:company)
	end

	test "company name should be present" do
		@company.name = "   "
		assert_not @company.valid?
	end

	test "company name should not be too long" do
		@company.name = "a" * 51
		assert_not @company.valid?
	end

	test "company name should be unique" do
		duplicate_company = @company.dup
		@company.save
		assert_not duplicate_company.valid?
	end

  test "company name should be downcase" do
    assert @company.name == @company.name.downcase
  end
	
	test "email should be valid" do
		@company.email = "example@email.com"
		assert @company.valid?
	end

	test "password should be present" do
		@company.password = "   "
		assert_not @company.valid?
	end
end