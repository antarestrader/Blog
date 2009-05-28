Given /^I am not authenticated$/ do
  # yay!
end

Given /^I am a visitor$/ do
  @me = Factory.build(:user)
end

Given(/^I am a signed in author$/) do
  @me = Factory(:author)
end