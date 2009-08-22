class FeedController < Application
  only_provides :xml
  
  before do
    @posts_availible = Post.all(domain_finder)
  end
  
  def rss
    @posts = @posts_availible.published.all(:limit=>25)
    render
  end
  
  def atom
    @posts = @posts_availible.published.all(:limit=>25)
    render
  end
  
end