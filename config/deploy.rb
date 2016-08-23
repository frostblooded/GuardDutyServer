# config valid only for current version of Capistrano
lock '3.6.0'

set :application, 'attendance_check'
set :repo_url, 'git@bitbucket.org:frostblooded/attendancecheck-rails-app.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/'

# Default value for :scm is :git
set :scm, :git

set :use_sudo, false

set :rails_env, 'production'

set :deploy_via, :copy

set :ssh_options, { port: 6019 }

set :keep_releases, 5

# Defaults to :db role
set :migration_role, :db

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Defaults to [:web]
set :assets_roles, [:web, :app]

server '37.157.182.179', user: 'deploy', roles: %w(app web dev), primary: true

desc 'run some rake db task'
task :migrate do
  on roles(:all) do
    within "#{current_path}" do
      execute :rake, "db:migrate", 'RAILS_ENV="production"'
    end
  end
end

desc "Precompile assets"
task :precompile_assets do
  on roles(:all) do
    within "#{current_path}" do
      execute :rake, "assets:precompile", 'RAILS_ENV="production"'
    end
  end
end

desc "Run server"
task :run_server do
  on roles (:all) do
    within "#{current_path}" do
      execute :rails, '-b 0.0.0.0', '-e production', '-d'
    end
  end
end

# after 'deploy:published', 'precompile_assets'
# after 'deploy:published', 'migrate'
# after 'deploy:published', 'run_server'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
