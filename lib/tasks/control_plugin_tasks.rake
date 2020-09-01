require 'rake/testtask'

# Tasks
namespace :control_plugin do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ControlPlugin'
  Rake::TestTask.new(:control_plugin) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :control_plugin do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_control_plugin) do |task|
        task.patterns = ["#{ControlPlugin::Engine.root}/app/**/*.rb",
                         "#{ControlPlugin::Engine.root}/lib/**/*.rb",
                         "#{ControlPlugin::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_control_plugin'].invoke
  end
end

Rake::Task[:test].enhance ['test:control_plugin']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:control_plugin', 'control_plugin:rubocop']
end
