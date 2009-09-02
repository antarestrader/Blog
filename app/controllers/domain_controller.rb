class DomainController < Application
  before :ensure_authenticated
  
  def index
    @domains = Domain.all
    render
  end
  
  #this is actually edit, but we do not need the extra method
  def show(domain_name)
    @target = Domain.get(domain_name)
    raise NotFound unless @target
    render
  end
  
  #def new
  
  #must also handle load and save operations
  #def create
  
  #def update(domain_name)
  
  #def destroy(domain_name)
  
end