class Category
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :index=>true
  property :description, String,:length=>255
  property :post_count, Integer, :writer => :private
  
  belongs_to :domain, :child_key=>[:domain_name]
  
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
    cnt = posts.published.count
    self.attribute_set(:post_count, cnt)
    self.save
    cnt
  end
  
end
