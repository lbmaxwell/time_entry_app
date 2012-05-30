#To deploy to staging...
#cap staging deploy:setup
#cap staging deploy:check
#cap staging deploy

#To deploy to prod
#cap production deploy:setup
#cap production deploy:check
#cap production deploy

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

task :production do
  puts "\n\e[0;31m   ######################################################################" 
  puts "   #\n   #       Are you REALLY sure you want to deploy to production?"
  puts "   #\n   #               Enter y/n + enter to continue\n   #"
  puts "   ######################################################################\e[0m\n" 

  role :web, "192.168.0.244" # Your HTTP server, Apache/etc
  role :app, "192.168.0.244" # This may be the same as your `Web` server

  # "role :db" (below) is only where migrations will be run.
  #The actual database server for the app is completely configured in config/database.yml.
  role :db,  "192.168.0.244", primary: true # This is where Rails migrations will run
end

task :staging do
  role :web, "192.168.0.241" # Your HTTP server, Apache/etc
  role :app, "192.168.0.241" # This may be the same as your `Web` server

  # "role :db" (below) is only where migrations will be run.
  #The actual database server for the app is completely configured in config/database.yml.
  role :db,  "192.168.0.241", primary: true # This is where Rails migrations will run
end

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
    #Lines below assumes prod server has environment variable of $RAILS_ENV="production"
    run "cd #{current_path}; rake assets:precompile"
    run "cd #{current_path}; RAILS_ENV=\"production\" rake db:migrate"

    #Restart web server - sudo not necessary with current configuration
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
