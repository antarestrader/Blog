class Application < Merb::Controller

  if Merb.config[:multidomain]
    before do
      d = params[:domains] = request.domain(5)
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
    @_old_template_roots = self.class._template_roots
    raise NotFound, "expected to find a path at #{@domain[:template_root]}." unless @domain[:template_root]
    self.class._template_roots << [@domain[:template_root],:_template_location]
    
    if DataMapper::Repository.adapters.has_key?(@domain[:database])
      DataMapper::Repository.context << DataMapper::repository(@domain[:database])
    end
  end
  
  def restore_domain
    self.class._template_roots = @_old_template_roots
    
    if DataMapper::Repository.adapters.has_key?(@domain[:database])
      DataMapper::Repository.context.pop
    end
  end
  
end