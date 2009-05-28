class PostController < Application

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
  
  def new
    @post = Post.new
    render :template=>'post_controller/edit'
  end
  
end
