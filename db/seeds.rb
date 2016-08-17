company = Company.create name: 'frostblooded',
                         password: 'foobarrr',
                         password_confirmation: 'foobarrr',
                         email: Faker::Internet.free_email,
                         confirmed_at: Time.zone.now

5.times do
  site = company.sites.create name: Faker::GameOfThrones.city

  5.times do
    site.workers.create(name: Faker::GameOfThrones.character,
                        password: 'foobarrr')
  end
end
