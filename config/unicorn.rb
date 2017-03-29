# set path to application
require 'dotenv/load'
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir


# Set unicorn options
worker_processes 2
preload_app true
timeout 90

# Set up socket location
listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{ENV['LOCAL_PATH_BACKUP']}/unicorn.stderr.log"
stdout_path "#{ENV['LOCAL_PATH_BACKUP']}/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/pids/unicorn.pid"
