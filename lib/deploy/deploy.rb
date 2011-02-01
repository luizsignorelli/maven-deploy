#!/usr/bin/ruby
load 'util/system'
load 'util/ui'
load 'util/maven'
load 'deploy/enviorment/prod'
load 'deploy/enviorment/dev'
load "app_servers/#{app_server}"

default_run_options[:pty] = true

set :super_pom do Pom.new("pom.xml") end
set :module_pom do Pom.new("#{app_module}/pom.xml") end
set :app_name, super_pom.project_name
set :app_server do AppServer.new(app_server_dir) end

namespace :app do

  desc "start app_server"
  task :start do
    sudo app_server.start
  end

  desc "stop app_server"
  task :stop do
    sudo app_server.stop
  end

  desc "stop and start app_server"
  task :restart do
    sudo app_server.stop
    sudo app_server.start
  end

  desc "show app server log"
  task :show_log do
    stream "tail -f #{app_server.show_log}"
  end

end