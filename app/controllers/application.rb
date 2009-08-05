class Application < Merb::Controller
  #???
  before do
    @categories = Category.all
  end
  
  before do
    p d = params[:domains] = request.domain
    raise NotFound, "No Known Domain: #{d}" unless Merb::Config[:domains].has_key?(d)
    @domain = Merb::Config[:domains][d]
  end
  
  before :set_template_roots
  after :restore_template_roots
  
  def set_template_roots
    @_old_template_roots = self.class._template_roots
    raise NotFound, "expected to find a path at #{@domain[:template_root]}." unless @domain[:template_root]
    self.class._template_roots << [@domain[:template_root],:_template_location]
  end
  
  def restore_template_roots
    self.class._template_roots = @_old_template_roots
  end
  
end