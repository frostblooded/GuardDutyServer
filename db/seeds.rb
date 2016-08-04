# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

company = Company.create name: 'frostblooded',
                         password: 'foobarrr',
                         password_confirmation: 'foobarrr',
                         email: Faker::Internet.free_email,
                         confirmed_at: Time.now
site = company.sites.create name: 'test site'

5.times do |i|
  site.workers.create(name: Faker::Name.name, password: 'foobarrr')
end