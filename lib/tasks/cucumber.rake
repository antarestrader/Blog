require 'cucumber/rake/task'



Cucumber::Rake::Task.new(:features)
namespace :merb_cucumber do 
  task :test_env do
    Merb.start_environment(:environment => "test", :adapter => 'runner')
  end
end


dependencies = ['merb_cucumber:test_env', 'db:automigrate']
task :features => dependencies


