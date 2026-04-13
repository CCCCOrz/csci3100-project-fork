Feature: user can create items and see items created

  As a user
  So that I can create items
  I want the items being showed to other users

Scenario: valid registration

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111"
  When I registered account "bob" with email name "1155222222", password "111111"
  When I registered account "cathy" with email name "1155333333", password "111111"
  When the following items exists:
    | name     | category    | price | owner |
    | battery  | Electronics | 10    | alice |
    | fan      | Furniture   | 20    | bob   |
    | scissors | Other       | 20    | cathy |
    | textbook | Books       | 30    | alice |
    | shirt    | Clothing    | 30    | bob   |
    | football | Sports      | 40    | cathy |
    | baseball | Sports      | 50    | alice |
    | camera   | Electronics | 50    | bob   |
    | trousers | Clothing    | 60    | cathy |
  When I registered account "david" with email name "1155444444", password "222222"
  When I login using account "david" with password "222222"
  Then I should see all items
  When I select "Price: low to high" from "sort"
  When I press "Search items"
  Then "battery" should appear before "fan"
