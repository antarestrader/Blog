class AdminController < Application
  
  before :ensure_authenticated
  
  def index
    @drafts = Post.drafts
    @pending = Post.pending
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
