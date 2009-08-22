class CategoryController < Application
  
  before :ensure_authenticated, :exclude => [:show]
  
  before do
    @categories_availible = Category.all(domain_finder)
  end
  
  layout 'post_controller'
  
  def show(id)
    category = @categories_availible.get(id)
    @headline = category.name
    @posts = category.posts.published
    render :template=>'post_controller/index', :layout=>'post_controller'
  end
  
  def index
    @categories = @categories_availible
    render
  end
  
end
