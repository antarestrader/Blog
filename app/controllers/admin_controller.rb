class AdminController < Application
  
  before :ensure_authenticated

  def index
    render
  end
  
end
