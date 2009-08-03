class FeedController < Application
  only_provides :xml
  
  def rss
    @posts = Post.published.all(:limit=>25)
    render
  end
  
  def atom
    @posts = Post.published.all(:limit=>25)
    render
  end
  
end