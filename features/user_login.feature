Feature: user can login

  As a user already has an account
  So that I can login
  I want the page accept my account

Scenario: user login

  Given I am on the home page
	When I registered account "aaa" with email name "1155111111", password "111111"
  When I fill in "name" with "aaa"
  When I fill in "password" with "111111"
	When I press "Login"
  Then I should see "Marketplace"

Scenario: not exited users

	Given I am on the home page
  When I fill in "name" with "someone_not_exist_lalala"
  When I fill in "password" with "111111"
	When I press "Login"
  Then I should see "Invalid name or password! Please enter again."
	