# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'attendance_check'
set :repo_url, 'git@bitbucket.org:frostblooded/attendancecheck-rails-app.git'

set :rails_env, 'production'

set :ssh_options, { port: 6019 }

# Defaults to :db role
# Set role to app as recommended by Capistrano README
set :migration_role, :app

set :conditionally_migrate, true

# Defaults to [:web]
set :assets_roles, [:web, :app]

# Create database
before 'deploy:migrate', 'deploy:db:create'

# Upload figaro YML to server before asset compiling
before 'deploy:updated', 'figaro_yml:setup'

server '37.157.182.179', user: 'deploy', roles: %w(app web dev db), primary: true
