class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :length=>250, :required=>true
  property :text, Text, :required=>true
  property :allow_comments, Boolean, :default=>true
  property :format, Enum['Markdown','HTML','Textile'], :default=>'Markdown'
  property :guid, String, :lazy=>true
  property :index, Integer, :index=>true
  
  property :published_at, DateTime
  property :updated_at, DateTime
  property :created_at, DateTime
  
  belongs_to :domain, :child_key=>[:domain_name], :required=>false
  
  has n, :categories, :through=> Resource
  has n, :comments
  
  #set index
  before :create do
    attribute_set(:index, 1 + (Post.max(:index,:domain_name=>self.domain_name) || 0)) unless self.index
  end
  
  class << self
    
    def published
      all(:published_at.not=>nil, :published_at.lte=>Time.now.utc.iso8601, :order=>[:published_at.desc])
    end
    
    def drafts
      all(:published_at=>nil,:order=>[:updated_at.desc])
    end
    
    def pending
      all(:published_at.not=>nil, :published_at.gt=>Time.now.utc.iso8601, :order=>[:published_at.asc])
    end
    
    def post_number(i)
      first(:index=>Integer(i))
    end
  end
  
  
  
  def published?
    published_at && published_at.to_time <= Time.now.utc
  end
  
  def pending?
    published_at && published_at.to_time > Time.now.utc
  end
  
  def state
    return "Published" if published?
    return "Pending" if pending?
    return "New Post" if new_record?
    return "Draft"
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
    uid = "tag:blog.antarestrader.com,2009:/post_id/#{attribute_get(:id)}"
    attribute_set :guid, uid
    save unless new_record?
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
    
    CategoryPost.all(:post_id=>id, :category_id=>remove).destroy! unless remove.empty?
    
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
