When(/^I go to the post managment page$/) do
  visit '/admin'
end

Then(/^I should see #{noun} in the list of (\w+)$/) do |noun,sel_id|
  @it = get_noun(noun)
  selector = "##{sel_id} #{id_selector(@it)}"
  webrat_session.response.should have_selector(selector)
end