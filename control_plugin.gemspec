require File.expand_path('../lib/control_plugin/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'control_plugin'
  s.version     = ControlPlugin::VERSION
  s.license     = 'GPL-3.0'
  s.authors     = ['Michael Costa']
  s.email       = ['michael.costa@mcos.nc']
  s.homepage    = 'https://www.mcos.nc'
  s.summary     = 'Grefon d\'actualisation du serveur Puppet.'
  # also update locale/gemspec.rb
  s.description = 'Le greffon d\'actualisation du server Puppet permet la mise à jour des données (hiera et manifests) du serveur Puppet.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
