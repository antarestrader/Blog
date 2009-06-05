class CategoryController < Application
  
  def show(id)
    category = Category.get(id)
    @headline = category.name
    @posts = category.posts.published
    render :template=>'post_controller/index', :layout=>'post_controller'
  end
  
end
