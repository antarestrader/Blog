class CategoryController < Application
  
  before :ensure_authenticated, :exclude => [:show]
  
  layout 'post_controller'
  
  def show(id)
    category = Category.get(id)
    @headline = category.name
    @posts = category.posts.published
    render :template=>'post_controller/index', :layout=>'post_controller'
  end
  
  def index
    @categories = Category.all
    render
  end
  
end
