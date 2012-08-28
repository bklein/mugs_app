set :application, "mugs_app"
set :repository,  "git@github.com:bklein/mugs_app.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "alachua_parser"

set :user, 'bklein'
set :deploy_to, "/www/demo/#{application}/"
# set :deploy_via, :remote_cache



role :web, "demo.slammervanity.com"                          # Your HTTP server, Apache/etc
role :app, "demo.slammervanity.com"                          # This may be the same as your `Web` server
role :db,  "demo.slammervanity.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false

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
    run "mkdir -p #{shared_path}/uploads"
    puts File.read("config/database.example.yml"), "#{shared_path}/datbase.yml"
    puts "Now edit the files in #{shared_path}" 
  end
  task :symlinks do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  
  after "deploy:update", "deploy:symlinks"
end


