Merb.logger.info("Loaded DEVELOPMENT Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_templates] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5
  c[:ignore_tampered_cookies] = true
  c[:log_auto_flush ] = true
  c[:log_level] = :debug

  c[:log_stream] = STDOUT
  # Or redirect logging into a file:
  c[:log_file]  = Merb.root / "log" / "development.log"
  
  c[:multidomain] = true #set this to true to use multiple domains
  
  Merb::BootLoader.after_app_loads do
    require 'multistatic'
    
    Merb::Cache.setup do
      domain_stores = Domain.all.map do |domain|
        sym = domain.domain_name.to_sym
        register(sym,Merb::Cache::MultiStore[Merb::Cache::PageStore[Merb::Cache::FileStore]], :domain=>domain.domain_name, :dir=>domain.public_root)
        sym
      end
      register(:default, Merb::Cache::AdhocStore[*domain_stores])
    end
  end
}
