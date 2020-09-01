require 'open3'
module ControlPlugin
  class HostsController < ::HostsController
    def deploy
      Foreman::Logging.logger('control_plugin').debug "Déploiement r10k"
      cmd = "/bin/sudo /usr/local/bin/r10k deploy environment production"
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        exit_status = wait_thr.value
        if exit_status == 0
          render 'control_plugin/layouts/deployed' 
        else
          render 'control_plugin/layouts/error'
        end
        Foreman::Logging.logger('control_plugin').debug "stdout: " + stdout.read
        Foreman::Logging.logger('control_plugin').debug "stderr: " + stderr.read
      end
    end
    
    def view
      Foreman::Logging.logger('control_plugin').debug "Affichage de la vue"
      render 'control_plugin/layouts/deploy' 
    end
  end
end
