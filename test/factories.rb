FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }

    after(:create) do |company|
      create_list(:site, 2, company: company)
    end
  end

  factory :site do
    name { Faker::GameOfThrones.city }

    after(:create) do |site|
      create_list(:worker, 2, sites: [site])
      create_list(:route, 2, site: site)
    end
  end

  factory :worker do
    name { Faker::GameOfThrones.character }
    password { Faker::Internet.password(8) }
  end

  factory :route do
    name { Faker::Pokemon.location }

    after(:create) do |route|
      create_list(:position, 2, route: route)
    end
  end

  factory :position do
    index { Random.rand(10) }
    latitude { Random.rand(50) }
    longitude { Random.rand(50) }
  end
end
