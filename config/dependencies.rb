# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.11"
dm_gems_version   = "0.9.11"
do_gems_version   = "0.9.11"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-core", merb_gems_version 
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version  
dependency("merb-cache", merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end
dependency "merb-helpers", merb_gems_version 
dependency "merb-mailer", merb_gems_version  
dependency "merb-slices", merb_gems_version  
dependency "merb-auth-core", merb_gems_version
dependency "merb-auth-more", merb_gems_version
dependency "merb-auth-slice-password", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version

dependency "data_objects", do_gems_version
dependency "do_sqlite3", do_gems_version 
dependency "do_mysql", do_gems_version 
dependency "dm-core", dm_gems_version         
dependency "dm-aggregates", dm_gems_version   
dependency "dm-migrations", dm_gems_version   
dependency "dm-timestamps", dm_gems_version   
dependency "dm-types", dm_gems_version        
dependency "dm-validations", dm_gems_version  
dependency "dm-serializer", dm_gems_version   

dependency "merb_datamapper", merb_gems_version

dependency "merb-haml", merb_gems_version
dependency "chriseppstein-compass", ">=0.6.6",:require_as=>'compass'

dependency "thoughtbot-factory_girl", ">=1.2.1", :require_as => nil #:require_as=>'factory_girl'
dependency "roman-merb_cucumber", ">=0.5.1", :require_as => nil #:require_as=>'cucumber'
dependency "rdiscount", ">=1.3.4"

dependency "webrat",   ">=0.4.4", :require_as => nil
dependency "cucumber", ">=0.3.92", :require_as => nil

dependency "chronic", ">=0.2.3"
dependency "tzinfo",  ">=0.3.13"
dependency "timecop", ">=0.2.1", :require_as => nil



