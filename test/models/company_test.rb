require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
	def setup
		@company = create(:company)
	end

	test 'company name is present' do
		@company.name = '   '
		assert_not @company.valid?
	end

	test 'company name is not too long' do
		@company.name = 'a' * 51
		assert_not @company.valid?
	end

	test 'company name is unique' do
		duplicate_company = @company.dup
		@company.save
		assert_not duplicate_company.valid?
	end

  test 'company name is downcase' do
    assert @company.name == @company.name.downcase
  end
	
	test 'email is valid' do
		@company.email = 'example@email.com'
		assert @company.valid?
	end

	test 'password is present' do
		@company.password = '   '
		assert_not @company.valid?
	end
end
