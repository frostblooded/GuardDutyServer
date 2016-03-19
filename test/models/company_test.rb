require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
	def setup 
		@company = Company.new(company_name: "Foobar", email: "dasdas@email.com", 
													 password: "asjfsajkdsa")
	end

	test "company name should be present" do
		@company.company_name = "   "
		assert_not @company.valid?
	end

	test "company name should not be too long" do
		@company.company_name = "a" * 51
		assert_not @company.valid?
	end

	test "company name should be unique" do
		duplicate_company = @company.dup
		@company.save
		assert_not duplicate_company.valid?
	end
end