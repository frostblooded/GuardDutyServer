source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails',                              '~> 5.0.0.1'
gem 'ledermann-rails-settings',           '~> 2.4.2'
gem 'exception_notification',             '~> 4.2.1'
gem 'devise',                             '~> 4.2.0'
gem 'figaro',                             '~> 1.1.1'
gem 'bcrypt',                             '~> 3.1.7'
gem 'whenever',                           '~> 0.9.4'
gem 'grape',                              '~> 0.16.2'
gem 'grape_on_rails_routes',              '~> 0.3.1'
gem 'bootstrap-sass',                     '~> 3.2.0.0'
gem 'sass-rails',                         '~> 5.0.6'
gem 'coffee-rails',                       '~> 4.2.1'
gem 'jquery-rails',                       '~> 4.2.1'
gem 'jquery-ui-rails',                    '~> 5.0.5'
gem 'rails-jquery-autocomplete',          '~> 1.0.3'
gem 'cancancan',                          '~> 1.15.0'
gem 'grape-cancan',                       '~> 0.0.2'

# Needed by production environment

group :development, :test do
  gem 'byebug',                  '~> 3.4.0'
  gem 'spring',                  '~> 1.1.3'
  gem 'faker',                   '~> 1.6.6'
  gem 'sqlite3',                 '~> 1.3.9'
end

group :development do
  gem 'web-console',             '~> 3.3.1'
  gem 'capistrano',              '~> 3.6.1'
  gem 'capistrano-rvm',          '~> 0.1.2'
  gem 'capistrano-rails',        '~> 1.1.7'
  gem 'capistrano-faster-assets','~> 1.0.2'
  gem 'capistrano-passenger',    '~> 0.2.0'
  gem 'rubocop',                 '~> 0.42.0'
end

group :test do
  gem 'minitest-reporters',      '~> 1.1.11'
  gem 'minitest-rails-capybara', '~> 3.0.0'
  gem 'simplecov',               '~> 0.11.2', require: false
  gem 'factory_girl_rails',      '~> 4.7.0'
  gem 'poltergeist',             '~> 1.10.0'
  gem 'phantomjs',               '~> 2.1.1.0', require: 'phantomjs/poltergeist'
  gem 'timecop',                 '~> 0.8.1'
end

group :production do
  gem 'mysql2',                  '~> 0.4.4'
  gem 'puma',                    '~> 3.4.0'
  gem 'uglifier',                '~> 3.0.2'
  gem 'rack-throttle',           '~> 0.4.0'
end
