require 'capistrano-deploy'
use_recipes :git, :bundle, :rails, :passenger, :whenever

server 'mystique.dreamhost.com', :web, :app, :db, :primary => true
set :user, 'artemave'
set :repository, "git://github.com/artemave/weatherdiff.git"
set :deploy_to, "/home/#{user}/weatherdiff.com"
set :enable_submodules, true

after 'deploy:update', 'bundle:install', 'whenever:update_crontab'
