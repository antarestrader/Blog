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
    Merb.logger.warn { "Restoring Domain #{domain}" }
    Post.all(:domain_name=>domain).destroy!
    Category.all(:domain_name=>domain).each do |cat|
      cat.destroy #this SHOULD take CategoryPost connections with it
    end
    categories.each do |e|
      Category.create(category_to_hash(e))
    end
    entries.each do |e|
      Post.create(entry_to_hash(e))
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
  
  def category_to_hash(e)
    { :name=>(e/'name/text()').to_s,
      :description=>(e/'description/text()').to_s,
      :domain_name=>domain}
  end
  
  def entry_to_hash(e)
    h = Hash.new
    h[:index] = Integer((e/'index/text()').to_s)
    h[:title] = (e/'title/text()').to_s
    h[:text] = (e/'text/pre/text()').to_s
    h[:guid] = (e/'guid/text()').to_s
    h[:published_at] = parse_date(e/'times/published/text()')
    h[:updated_at] = parse_date(e/'times/updated/text()')
    h[:created_at] = parse_date(e/'times/created/text()')
    
    h[:domain_name] = domain
    
    h[:categories] = (e/'categories/category').map {|c| Category.first(:name=>c.text) || c.text} 
    
    h
  end
  
  def parse_date(d)
    begin
      DateTime.parse(d.to_s)
    rescue ArgumentError
      return nil
    end
  end
end