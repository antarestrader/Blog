class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :not_null=>true
  property :text, Text
  property :allow_comments, Boolean, :default=>true
  property :format, Enum['Markdown','HTML','Textile'], :default=>'Markdown'
  property :guid, String, :lazy=>true
  
  property :published_at, DateTime
  property :updated_at, DateTime
  property :created_at, DateTime
  
  has n, :categories, :through=> Resource
  
  def self.published
    all(:published_at.not=>nil, :published_at.lte=>Time.now.iso8601, :order=>[:published_at.desc])
  end
  
  def self.drafts
    all(:published_at=>nil,:order=>[:updated_at.desc])
  end
  
  def self.pending
    all(:published_at.not=>nil, :published_at.gt=>Time.now.iso8601, :order=>[:published_at.asc])
  end
  
  def published?
    published_at && published_at.to_time <= Time.now
  end
  
  def pending?
    published_at && published_at.to_time > Time.now
  end
  
  def to_html
    format_text(text, format)
  end
  
  def summary
    format_text(divided_text[0], format)
  end
  
  def guid
    uid = attribute_get(:guid)
    return uid unless uid.nil?
    uid = "tag:blog.antarestrader.com:2009:/post/#{@id}"
    update_attributes :guid=>uid
    uid
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
    
    CategoryPost.all(:post_id=>id, :category_id=>remove).destroy!
    
    add.each {|c| categories << c}
    save
    delta.each {|c| c.clear_count}
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
