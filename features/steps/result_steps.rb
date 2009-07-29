Then /^I should see "(.*)"$/ do |text|
  webrat_session.response.body.to_s.should =~ /#{text}/m
end

Then /^I should not see "(.*)"$/ do |text|
  webrat_session.response.body.to_s.should_not =~ /#{text}/m
end

Then /^I should see an? (\w+) message$/ do |message_type|
  webrat_session.response.should have_xpath("//*[@class='#{message_type}']")
end

Then /^the (.*) ?request should fail/ do |_|
  webrat_session.response.should_not be_successful
end

Then(/^I should see #{noun}$/) do |noun|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    webrat_session.response.should have_selector(id_selector(it))
  end
end

Then(/^I should not see #{noun}$/) do |noun|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    webrat_session.response.should_not have_selector(id_selector(it))
  end
end

Then (/^#{noun} should have an? (.+) link$/) do |noun,link|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    webrat_session.response.should have_selector("#{id_selector(it)} a")
  end
  pending
end

Then(/^#{noun} should be on the (.+) page$/) do |noun,page|
  visit url(page.sub(/\s/,'_').to_sym)
  Then "I should see #{noun}"
end

Then(/^#{noun} should have an? (.+) page$/) do |noun,page|
  @it = get_noun(noun)
  ([@it].flatten).each do |it|
    visit resource(it)
  end
end
