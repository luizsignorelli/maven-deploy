class AppServer

  def initialize(app_server_dir)
    @jboss_ctrl = "/sbin/service jboss"
    @jboss_deploy_dir = "#{app_server_dir}/server/default/deploy"
    @jboss_log_dir = "#{app_server_dir}/server/default/log"
  end
    
  def start
    "#{@jboss_ctrl} start"
  end

  def stop
    "#{@jboss_ctrl} stop; true"
  end

  def show_log
    "#{@jboss_log_dir}/server.log"
  end
  
  def deploy_dir
    @jboss_deploy_dir
  end
end