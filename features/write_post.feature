Feature: Writing A Post
  In order to create content
  As an author
  I want to publish blog posts
  
  @passing
  Scenario: Publish a New Post
    Given I am a signed in author
    When I visit the new post page
    And write a post
    And click publish
    Then that post should be published
    And it should be on the home page
    And it should have a post page
    And it should allow comments
  
  @passing
  Scenario: Save a Draft
    Given I am a signed in author
    When I visit the new post page
    And write a post
    And click save draft
    Then that post should be saved
    And it should NOT be published
    And it should NOT appear on the home screen
    
  @passing
  Scenario: Finish a Draft
    Given I am a signed in author
    And there is an unpublished post
    When I go to the post managment page
    Then I should see that post in the list of drafts
    When I click on the edit link for that post
    Then I should see the post editing screen for it
    When I change the text
    And click publish
    Then that post should be published
    And it should appear on the home screen
    
  Scenario: Publish Later
    Given I am a signed in author
    When I visit the new post page
    And write a post
    And set the publication time to "publish at mid-night"
    And click publish
    Then that post should be pending
    And it should NOT be published
    And it should NOT appear on the home screen
    When it is after mid-night
    Then that post should be published
    And it should be on the home screen
    
  Scenario: Edit a Published Post
    Given I am a signed in author
    And I have published a post
    When I visit that post
    And click the "edit" link
    Then I should see the post editing screen for it
    When I change the text
    And click update
    Then that post should be published
    And the update time for it should be set
    