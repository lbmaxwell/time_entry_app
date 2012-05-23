require 'bundler/capistrano' #Added per http://railscasts.com/episodes/133-capistrano-tasks-revised?autoplay=true
require 'rvm/capistrano'

set :application, "time_entry_app"

#All of the lines in the next block added per Rails Casts Episode 133
set :user, 'tallyapp'
#set :password, '-ufr9+1ef2b='
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases on the server

task :precompile_assets do
  #Code below assumes prod server has environment variable of $RAILS_ENV="production"
  run "cd /home/tallyapp/time_entry_app/current; rake assets:precompile"
end

#set :scm, :subversion
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :repository,  "git@github.com:lbmaxwell/#{application}.git"
set :branch, 'master' #Added per http://help.github.com/deploy-with-capistrano/


role :web, "192.168.0.244"                          # Your HTTP server, Apache/etc
role :app, "192.168.0.244"                          # This may be the same as your `Web` server
#Note: "db role" (below) is only where migrations will be run. It is not the actual db server.
#The db server configuration options and setup settings are in config/database.yml.
role :db,  "192.168.0.244", primary: true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

#RVM specific stuff
set :rvm_type, :user
set :rvm_path, "$HOME/.rvm"
set :normalize_asset_timestamps, false
set :bundle_roles, [:app]

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   precompile_assets
   task :restart, :roles => :app, :except => { :no_release => true } do
     #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
     run "touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
