set :application, "weatherdiff.com"
set :repository,  "git://github.com/artemave/weatherdiff.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "mystique.dreamhost.com"
role :web, "mystique.dreamhost.com"
role :db,  "mysql.weatherdiff.com", :primary => true
