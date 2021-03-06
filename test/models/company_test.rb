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

  test 'company has its email as recipient by default' do
    assert @company.recipients.include? @company.email
    assert 1, @company.recipients.count
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

  test 'recipients is valid' do
    @company.recipients = []
    assert @company.valid?

    @company.recipients = nil
    assert_not @company.valid?
  end

  test 'email_wanted is valid' do
    @company.email_wanted = true
    assert @company.valid?

    @company.email_wanted = nil
    assert_not @company.valid?
  end

  test 'email_time is valid' do
    @company.email_time = '12:30'
    assert @company.valid?

    @company.email_time = '1e:3a'
    assert_not @company.valid?

    @company.email_time = nil
    assert_not @company.valid?
  end
end
