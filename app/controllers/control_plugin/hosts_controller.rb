require 'open3'
module ControlPlugin
  class HostsController < ::HostsController
    def deploy
      Foreman::Logging.logger('control_plugin').info "Déploiement r10k"
      cmd = "sudo /usr/local/bin/deploy_r10k_env.sh"
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        exit_status = wait_thr.value
        if exit_status == 0
          render 'control_plugin/layouts/deployed' 
        else
          render 'control_plugin/layouts/error'
        end
        Foreman::Logging.logger('control_plugin').info "stdout: " + stdout.read
        Foreman::Logging.logger('control_plugin').info "stderr: " + stderr.read
      end
    end
    
    def view
      Foreman::Logging.logger('control_plugin').info "Affichage de la vue"
      render 'control_plugin/layouts/deploy' 
    end
  end
end
