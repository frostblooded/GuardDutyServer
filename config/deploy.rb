# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'attendance_check'
set :repo_url, 'git@bitbucket.org:frostblooded/attendancecheck-rails-app.git'

set :use_sudo, false

set :rails_env, 'production'

set :deploy_via, :copy

set :ssh_options, { port: 6019 }

# Defaults to :db role
# Set role to app as recommended by Capistrano README
set :migration_role, :app

# Defaults to [:web]
set :assets_roles, [:web, :app]

server '37.157.182.179', user: 'deploy', roles: %w(app web dev), primary: true
