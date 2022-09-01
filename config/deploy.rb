# config valid for current version and patch releases of Capistrano
lock '~> 3.17.1'

set :application, 'ruby_advance'
set :repo_url, 'git@github.com:OraCl13/ruby_advance.git'
set :branch, 'main'
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/ruby_advance'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', '.env', 'config/redis.yml', 'config/cable.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/webpacker',
       'public/system', 'vendor', 'storage', 'public/uploads'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'sidekiq:restart'
    end
  end

  after :publishing, :restart
end
