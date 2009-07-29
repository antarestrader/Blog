Given /^I am not authenticated$/ do
  # yay!
end

Given /^I am a visitor$/ do
  @me = Factory.build(:user)
end

Given(/^I am a signed in author$/) do
  @me = Factory(:author)
  visit '/login'
  fill_in 'login', :with=>@me.login
  fill_in 'password', :with=>@me.password
  click_button "Log In"
end