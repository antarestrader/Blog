require 'rubygems'

if (local_gem_dir = File.join(File.dirname(__FILE__), 'gems')) && $BUNDLE.nil?
  puts "changing gem directory to '#{local_gem_dir}'"
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

require 'nokogiri'
require 'merb-core'
require 'htmlentities'

datasource = ARGV.pop

if ARGV.empty?
  puts "please supply one of more filenames on the commandline"
  exit
end

HTML = HTMLEntities.new

include FileUtils

# Load the basic runtime dependencies;
init_env = ENV['MERB_ENV'] || 'development'
Merb.load_dependencies(:environment => init_env)
Merb.start_environment(:environment => init_env, :adapter => 'runner')

DataMapper::Repository.context << DataMapper::repository(datasource.to_sym)

def strip_cdata(t)
  t.gsub(%r{<!\[CDATA\[(.*)\]\]>}m,'\1')
end

ARGV.each do |filename|
  puts "Importing for #{filename}:"
  doc = Nokogiri.XML(File.open(filename))
  categories = doc.xpath('/rss/channel/wp:category/wp:cat_name/text()').map {|t| strip_cdata(t.to_s)}
  puts "Categories:\n#{categories.join(', ')}"
  Category.all.destroy!
  categories.each do |c|
    Category.create(:name=>c)
  end
  doc.xpath('//item').each do |post|
    id = post.xpath('wp:post_id/text()').to_s
    title = HTML.decode(post.xpath('title/text()').to_s)
    published = post.xpath('wp:status/text()').to_s == 'publish' ? true : nil
    time = published && DateTime.parse(post.xpath('pubDate/text()').to_s)
    content = strip_cdata(post.xpath('content:encoded/text()').to_s)
    guid = post.xpath('guid/text()').to_s
    p = Post.create(:id=>id, :title=>title, :published_at=>time, :text=>content,
        :guid=>guid)
    categories = post.xpath('category[not(@domain)]/text()').map{ |category| 
      Category.first(:name=>strip_cdata(category.to_s)) 
    }
    p.categories = categories
    p.save
    puts "Imported (#{id}#{published ? '*' : ''}) #{title}" 
  end
end