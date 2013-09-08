require 'bundler/capistrano'

# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require "rvm/capistrano"

set :rvm_ruby_string, '1.9.2-p290@suh'
set :rvm_type, :user  # Don't use system-wide RVM

set :user, 'cseg'
set :domain, '192.168.99.121'
set :application, 'suh'

set :scm, :git
set :repository,  "ssh://#{user}@#{domain}/~/git/#{application}.git"
set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

# deploy config
set :deploy_to, "~/#{application}"
set :deploy_via, :remote_cache # :export
set :use_sudo, false

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

load 'deploy/assets'

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/home/user/.ssh/id_rsa)
## If you are using ssh_keysset :chmod755, "app config db lib public vendor script script/* public/disp*"

# Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # Manual Tasks

  namespace :fix do
    desc "Fix assets"
    task :assets do
      puts "=== Copy assets to public/assets ===\n"
      run "cd #{current_path};cp -R app/assets/images public/assets"
    end
  end

  namespace :db do

    desc "Syncs the database.yml file from the local machine to the remote machine"
    task :sync_yaml do
      puts "\n\n=== Syncing database yaml to the production server! ===\n\n"
      unless File.exist?("config/database.yml")
        puts "There is no config/database.yml.\n "
        exit
      end
      system "rsync -vr --exclude='.DS_Store' config/database.yml #{user}@#{application}:#{shared_path}/config/"
    end

    desc "Create Production Database"
    task :create do
      puts "\n\n=== Creating the Production Database! ===\n"
      puts "=== Load schema ===\n"
      run "cd #{current_path}; rake db:create RAILS_ENV=production"
      run "cd #{current_path}; rake db:schema:load RAILS_ENV=production"
      system "cap deploy:set_permissions"
    end

    desc "Migrate Production Database"
    task :migrate do
      puts "\n\n=== Migrating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate RAILS_ENV=production"
      system "cap deploy:set_permissions"
    end

    desc "Resets the Production Database"
    task :migrate_reset do
      puts "\n\n=== Resetting the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate:reset RAILS_ENV=production"
    end

    desc "Destroys Production Database"
    task :drop do
      puts "\n\n=== Destroying the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:drop RAILS_ENV=production"
      system "cap deploy:set_permissions"
    end

    desc "Moves the SQLite3 Production Database to the shared path"
    task :move_to_shared do
      puts "\n\n=== Moving the SQLite3 Production Database to the shared path! ===\n\n"
      run "mv #{current_path}/db/production.sqlite3 #{shared_path}/db/production.sqlite3"
      system "cap deploy:setup_symlinks"
      system "cap deploy:set_permissions"
    end

    desc "Populates the Production Database"
    task :seed do
      puts "\n\n=== Populating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:seed RAILS_ENV=production"
    end

  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_path}"
    run "rvm rvmrc trust #{current_release}"
  end
end

after "deploy", "rvm:trust_rvmrc"
after "deploy:update_code", "rvm:trust_rvmrc"

after "deploy", "deploy:fix:assets"

#require 'capistrano_recipes'