class PostController < Application
  
  before :ensure_authenticated, :exclude => [:index, :show]

  def index
    cnt = 10
    page = (params["page"] || 1).to_i
    offset = (page - 1)*cnt
    @posts = Post.published.first(cnt,:offset=>offset)
    raise NotFound if @posts.empty?
    @more = page + 1 if (Post.published.count > cnt*page)
    @less = page - 1 unless 1 == page
    render
  end
  
  def show(id)
    id ||=params["p"]
    @post = Post.published.get id
    raise NotFound unless @post
    render
  end
  
  def edit(id)
    @post = Post.published.get id
    raise NotFound unless @post
    render
  end
  
  def update(id)
    #TODO This is a mess!
    @post = Post.published.get id
    raise NotFound unless @post
    p = params['post']
    @post.categories.each {|c| c.update_attributes(:post_count=>nil)}
    @post.categories.clear
    @post.save
    @post.categories= (p.delete('category_ids') || []).map{|i| Category.get i}
    @post.categories.each {|c| c.update_attributes(:post_count=>nil)}
    @post.attributes= p
    @post.save
    redirect resource(@post)
  end
  
  def new
    @post = Post.new
    render :template=>'post_controller/edit'
  end
  
end
