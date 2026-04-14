Feature: The keyword filter can be auto completed

  As a user
  So that I can quickly find items
  I want the keyword filter give me things I have interest in

Scenario: main page keyword filter

  Given I am on the home page
  When I registered account "alice" with email name "1155111111", password "111111", location "Chung Chi College"
  When I registered account "bob" with email name "1155222222", password "111111", location "United College"
  When I registered account "derek" with email name "1155333333", password "111111", location "New Asia College"
  When the following items exists:
    | name     | category    | price | owner |
    | battery  | Electronics | 10    | alice |
    | fan      | Furniture   | 20    | bob   |
    | scissors | Other       | 20    | derek |
    | textbook | Books       | 30    | alice |
    | shirt    | Clothing    | 30    | bob   |
    | football | Sports      | 40    | derek |
    | baseball | Sports      | 50    | alice |
    | camera   | Electronics | 50    | bob   |
    | trousers | Clothing    | 60    | derek |
  When I registered account "david" with email name "1155444444", password "222222"
  Then I login using account "david" with password "222222"
  Then I should see keyword filter
  When I fill in "keyword" with "football"
  When I press "Search items"
  Then "football" should appear before "baseball"
