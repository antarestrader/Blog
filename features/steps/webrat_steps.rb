# Commonly used webrat steps
# http://github.com/brynary/webrat

When(/^I go to "(.*)"$/) do |path|
  visit path
end

When (/^I visit #{noun}$/) do |noun|
  @it = get_noun(noun)
  visit resource(@it)
end

When(/^I visit the (.+) page$/) do |path|
  visit url(path.sub(/\s/,'_').to_sym)
  webrat_session.response.should be_successful
end

When /^I press "(.*)"$/ do |button|
  click_button(button)
end

When(/^(?:I )?click (?:on )?the "(.+)" link$/) do |link|
  click_link(link)
end

When(/^I click on the (.+) link for #{noun}$/) do |link, noun|
  @it = get_noun(noun)
  click_link_within(id_selector(@it) ,link)
end

When /^I fill in "(.*)" with "(.*)"$/ do |field, value|
  fill_in(field, :with => value) 
end

When /^I select "(.*)" from "(.*)"$/ do |value, field|
  select(value, :from => field) 
end

When /^I check "(.*)"$/ do |field|
  check(field) 
end

When /^I uncheck "(.*)"$/ do |field|
  uncheck(field) 
end

When /^I choose "(.*)"$/ do |field|
  choose(field)
end

When /^I attach the file at "(.*)" to "(.*)" $/ do |path, field|
  attach_file(field, path)
end
