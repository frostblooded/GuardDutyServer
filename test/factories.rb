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
  end

  factory :site do
    sequence(:name) { |n| "Site #{n}" }

    after(:create) do |site|
      create_list(:worker, 3, sites: [site])
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
    created_at { Time.zone.now - rand(25).days }

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
        if activity.call?
          # Get randomly if call is good
          good_call = [true, false].sample

          if good_call
            activity.time_left = rand(1..59)
          else
            activity.time_left = 0
          end
        end
      end
    end
  end
end
