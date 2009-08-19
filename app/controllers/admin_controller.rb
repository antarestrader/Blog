class AdminController < Application
  
  before :ensure_authenticated

  def index
    @drafts = Post.drafts
    @pending = Post.pending
    render
  end
  
end
