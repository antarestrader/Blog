class AdminController < Application
  
  before :ensure_authenticated
  
  before do
    @posts_availible = Post.all(domain_finder)
  end

  def index
    @drafts = @posts_availible.drafts
    @pending = @posts_availible.pending
    render
  end
  
  def backup
    provides :xml
    @posts=Post.all
    render
  end
  
  def restore
    h params[:file].inspect
  end
  

  
end
