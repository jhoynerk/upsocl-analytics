root = "/home/upsocl/app/upsocl-analytics"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.miaplicacion.sock"
worker_processes 1
timeout 30
