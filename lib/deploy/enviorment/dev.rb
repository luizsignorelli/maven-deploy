set :deploy_from do 
  "#{app_module}/target"
end
set :deploy_to do
  "#{apps_dir}/#{app_name}/#{module_packaging}"
end
set :package do
  "#{artifact_name}.#{module_packaging}"
end

namespace :deploy do
  namespace :dev do
    desc "Deploy in development"
    task :default do
      set_up
      build
      scp_to_server
      link
    end
  end 
end

def link
  sudo "rm -f #{app_server.deploy_dir}/#{app_module}.#{module_packaging}"
  sudo "ln -s #{deploy_to}/#{package} #{app_server.deploy_dir}/#{app_module}.#{module_packaging}"
end

def scp_to_server
  sudo "mkdir -p #{deploy_to}"
  sudo "chown -R #{user}:#{user} #{apps_dir}"
  upload("#{deploy_from}/#{package}", "#{deploy_to}", :via => :scp)
  sudo "chown -R #{app_server_user}:#{app_server_user} #{apps_dir}"
end

def build
  system "mvn clean install -Pdev -f #{app_module}/pom.xml"
end

def set_up
  set :app_module, MavenDeploy::UI.ask_for_module( super_pom.modules )
  set :artifact_name, module_pom.final_name 
  set :module_packaging, module_pom.packaging
end

