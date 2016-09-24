FactoryGirl.define do
  factory :company do
    sequence(:name) { |n| "Company #{n}" }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    confirmed_at Time.zone.now
    report_locale I18n.default_locale

    after(:create) do |company|
      create_list(:site, 2, company: company)
    end

    factory :my_company do
      name 'frostblooded'
      email 'frostblooded@yahoo.com'
      password 'foobarrr'
    end

    factory :toni_company do
      name 'toni2'
      email 'amindov@abv.bg'
      password '12345678'
    end
  end

  factory :site do
    sequence(:name) { |n| "Site #{n}" }

    after(:create) do |site|
      create_list(:worker, 3, sites: [site])
      create_list(:route, 2, site: site)
    end
  end

  factory :worker do
    sequence(:name) { |n| "Worker #{n}" }
    password { Faker::Internet.password(8) }

    after(:create) do |worker|
      create_list(:random_activity, 5, worker: worker,
                                       site: worker.sites.first)

      unless worker.sites.empty?
        worker.update(company: worker.sites.first.company)
      end
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

      before(:create) do |activity|
        activity.time_left = rand(60) if activity.call?
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
