Feature: user can check their statistics
  As a user
  So that I can check my statistics
  I want my statistics to be shown to me

Scenario: checking statistics
  
  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  Then I login using account "alice" with password "111111"
  When I follow "Analytics Dashboard"
  Then I should see "Interactive Dashboard"
  Then I should see "Category Mix"
  Then I should see "Status Overview"
  Then I should see "Price Distribution"
  Then I should see "Community Activity"
  Then I should find my statistics
