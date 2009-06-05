class Category
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :unique_index=>true
  property :description, String,:length=>250
  property :post_count, Integer, :writer => :private
  
  has n, :posts, :through => Resource
  
  def post_count
    self.attribute_get(:post_count) || set_count 
  end
  
  def clear_count
    self.attribute_set(:post_count, nil)
    self.save
  end
  
  def inspect
    "#<Category(#{id}): #{name}>"
  end
  
private
  
  def set_count
    self.attribute_set(:post_count, posts.published.count)
    self.save
    post_count
  end
  
end
