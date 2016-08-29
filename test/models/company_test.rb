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
    duplicate_company = Company.new name: @company.name,
                                    email: @company.email + 'a'
    assert_not duplicate_company.valid?
  end

  test 'email is unique' do
    duplicate_company = Company.new name: @company.name + 'a',
                                    email: @company.email
    assert_not duplicate_company.valid?
  end

  test 'email is valid' do
    @company.email = 'example@email.com'
    assert @company.valid?

    @company.email = 'ewtwetwet@fwef.'
    assert_not @company.valid?
  end

  test 'password is present' do
    @company.password = '   '
    assert_not @company.valid?
  end
end
