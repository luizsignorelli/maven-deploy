set :prod_deploy_from do 
  "deploy/#{app_version}"
end
set :prod_deploy_to do
  "/opt/apps/#{app_name}/#{module_packaging}"
end
set :package do
  "#{app_module}-#{app_version}.#{module_packaging}"
end
set :archiva_url, "http://developer.netsite.com.br/archiva/repository/internal"

namespace :deploy do
  namespace :prod do
    desc "Deploy in production"
    task :default do
      set_up
      get_package

      scp_to_server
      jboss.stop
      link
      jboss.start
    end

    desc "Copy package to server via SCP"
    task :scp_to_server do
      upload("#{prod_deploy_from}/#{package}", "#{prod_deploy_to}", :via => :scp)
    end

    desc "Link package to jboss deploy"
    task :link do
      sudo "rm -f #{jboss_deploy}/#{app_module}.#{module_packaging}"
      sudo "ln -s #{prod_deploy_to}/#{package} #{jboss_deploy}/#{app_module}.#{module_packaging}"
    end

    task :clean do
      system "rm -rf #{prod_deploy_from}" 
    end
  end 
end

def get_package 
  system ("wget #{archiva_url}/#{app_name}/#{app_module}/#{app_version}/#{package}")
  mkdir "#{prod_deploy_from}/#{app_version}"
  system ("mv #{package} #{prod_deploy_from}/#{app_version}")
end

def set_up
   set :app_module, MavenDeploy::UI.ask_for_module( super_pom.modules )
   set :module_packaging, module_pom.packaging
   set :app_version, MavenDeploy::UI.ask_for_version( super_pom.version )
end

