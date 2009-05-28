class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :not_null=>true
  property :text, Text
  property :published_at, Time
  
  def self.published
    all(:published_at.not=>nil, :published_at.lte=>Time.now, :order=>[:published_at.desc]) #and before now
  end
  
  def to_html
    format_text(text)
  end
  
  def summary
    format_text(divided_text[0])
  end
  
  #returns true if there is summary
  def extended
    divided_text.length > 1
  end
  
private

  def preformat_text(t)
    t.sub("\n\n-----\n", "\n")
  end
  
  def divided_text
    @dt ||= text.split("\n\n-----\n")
  end
  
  def format_text(t)
    Markdown.new(preformat_text(t)).to_html
  end


end
