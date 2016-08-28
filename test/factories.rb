FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    confirmed_at Time.zone.now

    after(:create) do |company|
      create_list(:site, 2, company: company)
    end

    factory :my_company do
      name 'frostblooded'
      email 'frostblooded@yahoo.com'
      password 'foobarrr'
    end
  end

  factory :site do
    name { Faker::Name.name }

    after(:create) do |site|
      create_list(:worker, 2, sites: [site])
      create_list(:route, 2, site: site)
    end
  end

  factory :worker do
    name { Faker::GameOfThrones.character }
    password { Faker::Internet.password(8) }

    after(:create) do |worker|
      create_list(:random_activity, 5, worker: worker)
      worker.update(company: worker.sites.first.company) unless worker.sites.empty?
    end
  end

  factory :activity do
    created_at { Time.zone.now }

    factory :call_activity do
      category :call
      time_left { rand(60) }
    end

    factory :login_activity do
      category :login
    end

    factory :logout_activity do
      category :logout
    end

    factory :random_activity do
      category { [:call, :login, :logout].sample }

      after(:create) do |activity|
        activity.update(time_left: rand(60)) if activity.call?
      end
    end
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
