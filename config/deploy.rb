require "bundler/capistrano"
require 'new_relic/recipes'

set :stages, %w(production staging)
set :default_stage, "staging"

require 'capistrano/ext/multistage' # must be required after setting stages and default_stage

set :application, "action_log_service"
set :user,        "simfy"
set :use_sudo,    false
set :normalize_asset_timestamps, false # Do not touch asset folders in finalize_update task

set :scm,           :git
set :repository,    "git@github.com:simfy/#{application}.git"
set :deploy_to,     "/opt/simfy/app/#{application}"
set :branch,        "master"
set :keep_releases, 5

ruby_version = "1.9.3-p125"

after "bundle:install", "setup_environment:rehash_binaries"
after "deploy:create_symlink", "newrelic:notice_deployment"

def run_with_rails_env(cmd)
  run("RAILS_ENV=#{stage} #{cmd}")
end

namespace :setup_environment do
  desc "Create folders"
  task :create_folders do
    dirs = [deploy_to, shared_path, releases_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "mkdir -p #{dirs.join(' ')}"
  end

  desc "Install ruby"
  task :install_ruby do
    run "cd #{deploy_to} && rbenv install #{ruby_version}"
  end

  desc "Install bundler"
  task :install_bundler do
    run "cd #{deploy_to} && gem install bundler"
    rehash_binaries
  end

  desc "Rehash rbenv binaries"
  task :rehash_binaries do
    run "cd #{deploy_to} && rbenv rehash"
  end

  desc "Setup server for first deployment: Create folders, install and set ruby version"
  task :setup, :except => { :no_release => true } do
    create_folders
    install_ruby
    
    # Set ruby version for this app
    run "cd #{deploy_to} && rbenv local #{ruby_version}"
    install_bundler

    # Initial code checkout
    deploy.update
  end
end

namespace :deploy do
  desc "Bootstrap app including initial unicorn start plus nginx configuration and restart"
  task :bootstrap do
    unicorn.setup
    nginx.setup
  end

  desc "Restart"
  task :restart do
    unicorn.restart
  end

  desc "Start"
  task :start do
    unicorn.start
  end

  desc "Stop"
  task :stop do
    unicorn.stop
  end

  namespace :nginx do
    desc "Update nginx configuration"
    task :update_conf do
      run "cp #{current_path}/config/nginx-#{stage}.conf /var/simfy/unicorn/nginx-#{stage}-#{application}.conf"
    end

    desc "Setup nginx: Copy the app specific nginx configuration to global conf dir and restart nginx"
    task :setup do
      update_conf
      restart
    end

    desc "Restart nginx"
    task :restart do
      stop
      start
    end

    desc "Stop nginx"
    task :stop do
      run "stop_nginx"
    end

    desc "Start nginx"
    task :start do
      run "run_nginx --production"
    end
  end

  namespace :unicorn do
    desc "Create pid file and boot unicorn for first time"
    task :setup do
      run "cd #{current_path} && RAILS_ENV=#{stage} U boot #{current_path}"
    end

    desc "Zero-downtime restart of Unicorn"
    task :restart, :except => { :no_release => true } do
      run_with_rails_env "U cycle #{application}"
    end

    desc "Start server"
    task :start, :except => { :no_release => true } do
      run_with_rails_env "U run #{application}"
    end

    desc "Stop unicorn"
    task :stop, :except => { :no_release => true } do
      run_with_rails_env "U stop #{application}"
    end 

    desc "Status of unicorn"
    task :status, :except => { :no_release => true } do
      run_with_rails_env "U status #{application}"
    end
  end


end