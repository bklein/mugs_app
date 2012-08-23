set :application, "mugs_app"
set :repository,  "git@github.com:bklein/mugs_app.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "alachua_parser"

set :user, 'bklein'
set :deploy_to, "/www/#{application}/"
set :deploy_via, :remote_cache
set :user_sudo, false


role :web, "demo.slammervanity.com"                          # Your HTTP server, Apache/etc
role :app, "demo.slammervanity.com"                          # This may be the same as your `Web` server
role :db,  "demo.slammervanity.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :setup do
    run "mkdir -p #{shared_path}/config"
    puts File.read("config/database.example.yml"), "#{shared_path}/datbase.yml"
    puts "Now edit the files in #{shared_path}" 
  end
  
end


