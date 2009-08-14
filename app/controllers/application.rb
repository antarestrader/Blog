class Application < Merb::Controller

  if Merb.config[:multidomain]
    Merb.logger.info { "Setting up dispatch for Multiple Domains" }
    Merb.logger.debug { "  domains: #{Merb::Config[:domains].inspect}" }

    before do
      d = params[:domain] = request.domain(5)
      Merb.logger.debug { "  domain is: #{d}" }
      raise NotFound, "No Known Domain: #{d}" unless Merb::Config[:domains].has_key?(d)
      @domain = Merb::Config[:domains][d]
    end
    
    before :set_domain
    after :restore_domain
  end
  
  #used in sidebar
  before do
    @categories = Category.all
  end
  
  def set_domain
    @_old_template_roots = self.class._template_roots.dup
    Merb.logger.debug { "  template root was:\n  #{@_old_template_roots.map{|i| i[0]}.join("\n  ")}" }
    raise NotFound, "expected to find a path at #{@domain[:template_root]}." unless @domain[:template_root]
    Merb.logger.info { "Dispatching for domain: #{@domain[:name]} (#{@domain[:template_root]})" }
   
    self.class._template_roots << [@domain[:template_root],:_template_location]
    Merb.logger.debug { "  template root now:\n  #{self.class._template_roots.map{|i| i[0]}.join("\n  ")}" }
    Merb.logger.debug { "  old template template root is:\n  #{@_old_template_roots.map{|i| i[0]}.join("\n  ")}" }
    ::Application.set_repository(@domain[:database])
  end
  
  def restore_domain
    self.class._template_roots = @_old_template_roots
    Merb.logger.debug { "restoring template root: #{self.class._template_roots.inspect}" }
    ::Application.reset_repository(@domain[:database])
  end
  
  def self.set_repository(r)
    if DataMapper::Repository.adapters.has_key?(r)
      Merb.logger.debug { "  using database: #{r.inspect}" }
      DataMapper::Repository.context << DataMapper::repository(r)
    end
  end
  
  def self.reset_repository(r=nil)
    if DataMapper::Repository.adapters.has_key?(r) || r.nil?
      DataMapper::Repository.context.pop
    end
  end
  
end