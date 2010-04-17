Feature: The Home Page
  In order view recent posts
  As a reader
  I want read the home page
  
@passing
Scenario: Seeing Public Posts
  Given there are 10 published posts
  And I am a visitor
  When I visit the home page
  Then I should see those posts

@active
Scenario: Reading More of a Post
  Given there is a published post
  And I am a visitor
  When I visit the home page
  Then I should see that post
  And that post should have a Read More link
  When I click on the Read More link for that post
  Then I should see the page for that post

@passing
Scenario: Reading Older Posts
  Given there are 11 published posts
  And I am a visitor
  When I visit the home page
  Then I should see the 10th post
  And I should not see the 11th post
  When I click on the "older posts" link
  Then I should see the 11th post

