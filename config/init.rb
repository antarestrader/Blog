# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm :datamapper
use_test :rspec
use_template_engine :haml
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = 'fb41e88bc8a478b0e8a4af0b3072b0757ce4a6b3'  # required for cookie session store
  c[:session_id_key] = '_blog_session_id' # cookie session id key, defaults to "_session_id"
  c[:compass] = {
     :stylesheets => 'app/stylesheets',
     :compiled_stylesheets => 'public/stylesheets'
   }
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  begin
    Domain.load_yaml(Merb.root/ 'config' / 'blogs.yml') if Merb::Config[:multidomain] && Domain.count == 0
  rescue 
  end
end
