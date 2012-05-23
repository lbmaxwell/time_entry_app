require 'bundler/capistrano'
require 'rvm/capistrano'

#Standard options
set :application, "time_entry_app"
set :user, 'tallyapp'
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

role :web, "192.168.0.244" # Your HTTP server, Apache/etc
role :app, "192.168.0.244" # This may be the same as your `Web` server

# "role :db" (below) is only where migrations will be run.
#The actual database server for the app is completely configured in config/database.yml.
role :db,  "192.168.0.244", primary: true # This is where Rails migrations will run

#SCM options
set :scm, :git
set :repository,  "git@github.com:lbmaxwell/#{application}.git"
set :branch, 'master' #Added per http://help.github.com/deploy-with-capistrano/

#RVM specific options
set :rvm_type, :user
set :rvm_path, "$HOME/.rvm"
set :normalize_asset_timestamps, false
set :bundle_roles, [:app]

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    #Line below assumes prod server has environment variable of $RAILS_ENV="production"
    run "cd #{current_path}; rake assets:precompile"

    #Restart web server - sudo not necessary with current configuration
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
