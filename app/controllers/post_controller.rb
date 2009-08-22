class PostController < Application
  
  before :ensure_authenticated, :exclude => [:index, :show]
  
  before do
    @posts_availible = Post.all(domain_finder)
    @posts_availible = @posts_availible.published unless session.authenticated?
  end

  def index
    cnt = 10
    page = (params["page"] || 1).to_i
    offset = (page - 1)*cnt
    @posts = @posts_availible.published.first(cnt,:offset=>offset)
     
    if @posts.empty?
      return render("<h2>There are not yet any posts</h2>") if @posts_availible.published.count == 0
      raise NotFound
    end
    @more = page + 1 if (@posts_availible.published.count > cnt*page)
    @less = page - 1 unless 1 == page
    render
  end
  
  def show(index)
    index ||= params["p"]
    @post = @posts_availible.post_number index
    raise NotFound, h([index,@posts_availible].inspect) unless @post
    display @post
  end
  
  def edit(index)
    @post = @posts_availible.post_number index
    raise NotFound unless @post
    @action = resource(@post)
    render
  end
  
  def update(index)
    @post = @posts_availible.post_number index
    raise NotFound unless @post
    @post.categories= get_categories
    @post.attributes= params['post']
    @post.domain= domain[:database]
    set_publication(@post,params)
    if @post.save && (@post.published? || @post.pending?)
      redirect resource(@post)
    else
      @action = resource(@post) 
      Merb.logger.info { "Error saving post: \"#{@post.errors.inspect}\"" } unless @post.errors.empty?
      return render(:template=>'post_controller/edit') #need action to keep errors around
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
    @post.categories= get_categories
    @post.attributes= params['post']
    @post.domain= domain[:database]
    set_publication(@post,params)
    unless @post.save
      @action = url(:posts) 
      Merb.logger.info { "Error saving post: \"#{@post.errors.inspect}\"" }
      return render(:template=>'post_controller/edit')
    end
    if @post.published? || @post.pending?
      redirect resource(@post)
    else
      redirect resource(@post, :edit)
    end
  end
  
  def delete(id)
    @post = @posts_availible.index id
    raise NotFound unless @post
    render
  end
  
  def destroy(id)
    @post = @posts_availible.index id
    raise NotFound unless @post
    return redirect resource(@post) unless params[:submit] == "Delete" #handle cancel button
    Merb.logger.info { "Deleting post: #{@post.title || @post.index}" }
    @post.destroy
    redirect url(:admin)
  end
  
private
  
  def set_publication(post,params)
    case params['submit']
      when 'Post'
        post.published_at = Time.now.utc
      when 'Edit'
        nil
      when 'Save Draft'
        post.published_at = nil
      when 'Publish At'
        post.published_at = Chronic.parse(params['publication_time']).utc
    end
  end
  
  def get_categories
    p = params['post']
    (p.delete('category_ids') || []).map{|i| Category.get i}
  end
  
end
