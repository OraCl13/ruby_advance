server '161.35.212.31', user: 'deployer', roles: %w{web app db}, primary: true

role :app, %w{deployer@161.35.212.31}
role :web, %w{deployer@161.35.212.31}
role :db,  %w{deployer@161.35.212.31}

set :rails_env, :production
set :stage, :production

set :ssh_options, {
  keys: %w(/Users/ostap/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 4321
}
