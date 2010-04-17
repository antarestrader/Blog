class Application < Merb::Controller
  
  #depreciated
  def self.set_repository(r)
    if DataMapper::Repository.adapters.has_key?(r)
      Merb.logger.debug { "  using database: #{r.inspect}" }
      DataMapper::Repository.context << DataMapper::repository(r)
    end
  end

  #depreciated
  def self.reset_repository(r=nil)
    if DataMapper::Repository.adapters.has_key?(r) || r.nil?
      DataMapper::Repository.context.pop
    end
  end
  
  if Merb.config[:multidomain]
    Merb.logger.info { "Setting up dispatch for Multiple Domains" }
    before do
      d = params[:domain] = request.domain(5)
      Merb.logger.debug { "  domain is: #{d}" }
      raise NotFound, "No Known Domain: #{d}" unless @domain = Domain.get(d)
    end
    
    before :set_domain
    after :restore_domain
    
  end
  
  #Set up this call for the spesified domain 
  #Note Logging calls are indented for easier reading
  def set_domain
    #Save previous root
    @_old_reload_templates, Merb::Config[:reload_templates] = Merb::Config[:reload_templates], true
    @_old_template_roots = self.class._template_roots.dup
      Merb.logger.debug { "  template root was:\n  #{@_old_template_roots.map{|i| i[0]}.join("\n  ")}" }

    Merb.logger.info { "Dispatching for domain: #{@domain.domain_name} (#{@domain.template_root})" }
    
    #push our Route onto the stack
    self.class._template_roots << [@domain.template_root,:_template_location]
      Merb.logger.debug { "  template root now:\n  #{self.class._template_roots.map{|i| i[0]}.join("\n  ")}" }
      
  end
  
  def restore_domain
    self.class._template_roots = @_old_template_roots
    Merb::Config[:reload_templates] = @_old_reload_templates
      Merb.logger.debug { "restoring template root: #{self.class._template_roots.inspect}" }

  end
  
  def domain
    @domain ||= Domain.new
  end
    
  def domain_finder
    if Merb.config[:multidomain]
      {:domain_name=>@domain.domain_name}
    else
      {}
    end
  end
  
  before do
    @categories = Category.all(domain_finder)
  end

end