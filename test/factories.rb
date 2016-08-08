FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }

    after(:create) do |company|
      create_list(:site, 5, company: company)
    end
  end

  factory :site do
    name { Faker::GameOfThrones.city }

    after(:create) do |site|
      create_list(:worker, 5, sites: [site])
    end
  end

  factory :worker do
    name { Faker::GameOfThrones.character }
    password { Faker::Internet.password(8) }
  end
end