# config/puma.production.rb
workers 2
threads 1, 6

app_dir = "/home/deploy/psy_bot"
shared_dir = "#{app_dir}/tmp"

environment "production"

bind "unix://#{shared_dir}/sockets/puma.sock"

pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"

stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

activate_control_app

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
