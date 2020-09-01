Rails.application.routes.draw do
  get 'view', to: 'control_plugin/hosts#view'
  get 'deploy', to: 'control_plugin/hosts#deploy'
end
