module ControlPlugin
  class Engine < ::Rails::Engine
    engine_name 'control_plugin'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    initializer 'control_plugin.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :control_plugin do
        requires_foreman '>= 1.16'

        security_block :control_plugin do
          permission :deploy_control_plugin, :'control_plugin/hosts' => [:view, :deploy]
        end
        add_permissions_to_default_roles Role::ORG_ADMIN => [:deploy_control_plugin]
        
        # add menu entry
        menu :admin_menu, :template,
             url_hash: { controller: :'control_plugin/hosts', action: :view },
             caption: 'Actualiser environnement',
             parent: :administer_menu,
             first: true
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ControlPlugin::HostExtensions)
        HostsHelper.send(:include, ControlPlugin::HostsHelperExtensions)
      rescue => e
        Rails.logger.warn "ControlPlugin: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ControlPlugin::Engine.load_seed
      end
    end

    initializer 'control_plugin.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'control_plugin'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
