class Domain
  include DataMapper::Resource
  
  property :domain_name, String, :length=>80, :key=>true
  property :template_root, FilePath, :length=>255
  property :public_root, FilePath, :length=>255
  property :title, String, :length=>140
  property :description, Text #used in feeds etc...
  
  
  class<<self
    
    def load_yaml(path_or_file)
       Merb.logger.info {"Overwriting Domains with information from file"}
      hash = if path_or_file.kind_of? IO
        YAML.load(path_or_file)
      else
        YAML.load_file(path_or_file)
      end
      self.all.destroy!
      hash.each_pair do |domain, values|
        resource = create(values.merge(:domain_name=>domain))
        if resource.new_record?
          raise PersistenceError, 
                "Domain not saved: #{resource.domain_name}, :errors => #{resource.errors.inspect}" 
        end
        Merb.logger.debug {"  - Added Domain: #{domain}"}
      end
      self.all
    end
    
  end
  
end