if ENV['MERB_ENV'] == 'production'
  puts "I will not destroy all you production data!"
  puts "switching to 'test' mode"
  ENV['MERB_ENV'] = 'test'
end

# Sets up the Merb environment for Cucumber (thanks to krzys and roman)
#require "rubygems"
require "bundler"

module Bundler
  def self.require(*groups)
    runtime.require(*groups)
  end
end

require "merb-core"
require "spec"
require "merb_cucumber/world/webrat"
require "merb_cucumber/helpers/datamapper"
require "timecop"


# Uncomment if you want transactional fixtures
# Merb::Test::World::Base.use_transactional_fixtures

# Quick fix for post features running Rspec error, see 
# http://gist.github.com/37930
def Spec.run? ; true; end

Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')
DataMapper.auto_migrate! if Merb.orm == :datamapper

require "factory_girl"
require Merb.root/'spec'/'factories'/'factories.rb'

Before do
  Post.all.destroy!
end

After do
  Timecop.return
end