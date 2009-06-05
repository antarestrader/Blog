class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :not_null=>true
  property :text, Text
  property :guid, String #This field is used to preserve the guid from old Wordpress posts new post should leave as nil
  property :format, Enum['Markdown','HTML','Textile'], :default=>'Markdown'
  property :published_at, DateTime
  
  property :updated_at, DateTime
  property :created_at, DateTime
  
  has n, :categories, :through=> Resource
  
  def self.published
    all(:published_at.not=>nil, :published_at.lte=>Time.now, :order=>[:published_at.desc])
  end
  
  def to_html
    format_text(text, format)
  end
  
  def summary
    format_text(divided_text[0], format)
  end
  
  #returns true if there is summary
  def extended
    divided_text.length > 1
  end
  
  def categories=(new_set)
    old_set = categories
    delta = (old_set | new_set) - (old_set & new_set)
    return new_set if delta.empty?
    remove = (old_set - new_set).map {|c| c.id}
    add = new_set - old_set
    
    delta.each {|c| c.clear_count}
    
    CategoryPost.all(:post_id=>id, :category_id=>remove).destroy!
    
    add.each {|c| categories << c}
    save
  end
   
private

  def divider
    %r{(\n\s*-----\s*\n|<!--more-->)}m
  end

  def preformat_text(t)
    t.gsub(divider, "\n\n")
  end
  
  def divided_text
    @dt ||= text.split(divider)
  end
  
  def format_text(t, format)
    case format
      when 'Markdown'
        Markdown.new(preformat_text(t)).to_html
      when 'HTML'
        t
    end
  end


end
