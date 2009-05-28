Given(/^there are (\d+) ((?:un)?published) posts$/) do |n, pub|
  post = (pub == "published") ? :published_post : :post 
  n = n.to_i
  @posts = []
  n.times do
    @posts << Factory.create(post)
  end
end

Given(/^there is an? ((?:un)?published) post$?/) do |pub|
  post = (pub == "published") ? :published_post : :post
  @post = Factory.create(post)
end

Then(/^#{noun} should be published$/) do |noun|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    it.should be_published
  end
end

Then (/^#{noun} should allow comments$/) do |noun|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    it.should allow_comments
  end
end