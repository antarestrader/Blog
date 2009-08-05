class PostController < Application
  
  before :ensure_authenticated, :exclude => [:index, :show]

  def index
    cnt = 10
    page = (params["page"] || 1).to_i
    offset = (page - 1)*cnt
    @posts = Post.published.first(cnt,:offset=>offset)
     
    if @posts.empty?
      return render "<h2>There are not yet any posts</h2>" if Post.published.count == 0
      raise NotFound
    end
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
    @post = Post.get id
    @action = resource(@post)
    raise NotFound unless @post
    render
  end
  
  def update(id)
    @post = Post.get id
    raise NotFound unless @post
    p = params['post']
    @post.categories= (p.delete('category_ids') || []).map{|i| Category.get i}
    @post.attributes= p
    set_publication(@post,params)
    @post.save
    if @post.published?
      redirect resource(@post)
    else
      redirect resource(@post, :edit)
    end
  end
  
  def new
    @post = Post.new
    @action = url(:posts)
    render :template=>'post_controller/edit'
  end
  
  def create
    p = params['post']
    @post = Post.new
    @post.categories= (p.delete('category_ids') || []).map{|i| Category.get i}
    @post.attributes= p
    set_publication(@post,params)
    return render(:template=>'post_controller/edit') unless @post.save
    if @post.published?
      redirect resource(@post)
    else
      redirect resource(@post, :edit)
    end
  end
  
private
  
  def set_publication(post,params)
    case params['submit']
      when 'Post'
        post.published_at = Time.now.utc
      when 'Save Draft'
        post.published_at = nil
      when 'Publish At'
        post.published_at = Chronic.parse(params['publication_time']).utc
    end
  end
  
end
