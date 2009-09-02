class Restore
  attr_writer :domain
  attr_reader :doc
  
  
  def initialize(file)
    @doc = ::Nokogiri.XML(file)
  end
  
  def inspect
    "<Restore>"
  end
  
  def run!
    Post.all(:domain=>domain).destroy!
    Category.all(:domain=>domain).each do |cat|
      cat.destroy #this SHOULD take CategoryPost connections with it
    end
    categories.each do |e|
      Category.create(Restore.category_to_hash(e))
    end
    entries.each do |e|
      Post.create(Restore.entry_to_hash(e))
    end
  end
  
  def domain
    @domain ||= @doc.xpath('/backup/@domain').to_s
  end
  
  def date
    DateTime.parse(@doc.xpath('/backup/@date').to_s)
  end
  
  def entries
    @doc.xpath('/backup/posts/entry')
  end
  
  alias :posts :entries
  
  def categories
    @doc.xpath('/backup/categories/category')
  end
  
  def title_set
    entries.map {|e| e/('title/text()')}
  end
  
  def self.category_to_hash(e)
    { :name=>(e/'name/text()').to_s,
      :description=>(e/'description/text()').to_s,
      :domain=>domain}
  end
  
  def self.entry_to_hash(e)
    h = Hash.new
    h[:index] = Integer(e/('index/text()'))
    h[:title] = e/('title/text()').to_s
    h[:text] = (e/'text/pre/text()').to_s
    h[:guid] = (e/'guid/text()').to_s
    h[:published_at] = DateTime.parse((e/'time/published/text()').to_s)
    h[:updated_at] = DateTime.parse((e/'time/updated/text()').to_s)
    h[:created_at] = DateTime.parse((e/'time/created/text()').to_s)
    
    h[:domain] = domain
    
    h[:categories] = (e/'categories/category').map {|c| Category.first(:name=>c.text) || c.text} 
    
    h
  end
end