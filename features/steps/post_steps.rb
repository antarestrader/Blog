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

Given (/^#{noun} (?:has|have) published a post$/) do |author|
  @author = get_noun(author)
  Timecop.freeze(Chronic.parse("yesterday")) do
    @post = Factory.create(:published_post)  #TODO , :author=>@author)
  end
end

When (/^(?:I )?write a post$/) do
  @post = Factory.build(:post)
  fill_in 'title', :with=>@post.title
  fill_in 'text', :with=>@post.text
end

When (/^(?: I )?set the publication time to "(.*)"$/) do |time|
  fill_in "publication_time", :with=>time
end

When (/^I change the text$/) do
  #get text from page....
  fill_in 'text', :with=>@post.text.upcase
end

When (/^click publish$/) do
  click_button "Post"
  webrat_session.response.should be_successful
  webrat_session.current_url.should_not =~ %r[edit/?$]
  @post = Post.first(:title=>@post.title)
  @post.should_not be_nil
end

When (/^click edit$/) do
  click_button "Edit"
  webrat_session.response.should be_successful
  @post = Post.first(:title=>@post.title)
end

When (/^click publish at$/) do
  click_button "Publish At"
  webrat_session.response.should be_successful
  @post = Post.first(:title=>@post.title)
end

When (/^click save draft$/) do
  click_button "Save Draft"
  @post = Post.first(:title=>@post.title)
end

Then(/^#{noun} should be published$/) do |noun|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    it.should be_published
  end
end

Then(/^#{noun} should be pending$/) do |noun|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    it.should be_pending
  end
end

Then(/^#{noun} should NOT be published$/) do |noun|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    it.should_not be_published
  end
end

Then(/^#{noun} should appear on the home screen$/) do |noun|
  @it = get_noun(noun)
  visit '/'
  ([@it].flatten).each do |it|
    webrat_session.response.body.to_s.should =~ /#{it.title}/m
  end
end

Then(/^#{noun} should NOT appear on the home screen$/) do |noun|
  @it = get_noun(noun)
  visit '/'
  ([@it].flatten).each do |it|
    webrat_session.response.body.to_s.should_not =~ /#{it.title}/m
  end
end

Then(/^#{noun} should allow comments$/) do |noun|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    it.allow_comments.should be_true
  end
end

Then(/^#{noun} should be saved$/) do |noun|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    it.should_not be_a_new_record
  end
end

Then(/^I should see the post editing screen for #{noun}$/) do |noun|
  @it = get_noun(noun)
  webrat_session.current_url.should =~ %r[#{resource(@it,:edit)}/?$]
end

Then(/^the update time for #{noun} should be set$/) do |noun|
  @it = get_noun(noun)
  @it.updated_at.asctime.should == Time.now.asctime #timecop?
end