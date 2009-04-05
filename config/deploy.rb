set :user, 'artemave'
ssh_options[:keys] = %w{/home/artem/.ssh/id_rsa}
set :domain, 'mystique.dreamhost.com'
set :project, 'weatherdiff'
set :application, "weatherdiff.com"
set :applicationdir, "/home/#{user}/#{application}"

set :scm, 'git'
set :repository, "git://github.com/artemave/weatherdiff.git"
set :branch, 'master'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, domain
role :web, domain
role :db,  domain, :primary => true

set :deploy_to, applicationdir
set :deploy_via, :remote_cache
set :use_sudo, false

namespace :deploy do
	task :restart do
		run "touch #{current_path}/tmp/restart.txt"
	end

	task :load_submodules do
		run "cd #{current_path}; git submodule update --init"
	end
end

after "deploy:update", "deploy:load_submodules"
