Feature: user can register

  As a new user
  So that I can register
  I want the page accept my account

Scenario: valid registration

  Given I am on the home page
  When I follow "Register a new account"
  Then I should see "Sign up for Account"
  When I fill in "user_name" with "aaaa"
  When I fill in "user_email" with "1155123456@link.cuhk.edu.hk"
  When I select "Chung Chi College" from "user_location"
  When I fill in "password" with "aaaaaa"
  When I fill in "password_confirmation" with "aaaaaa"
  When I press "Register"
  Then I should see "User was successfully created!"

Scenario: invalid password

  Given I am on the home page
  When I follow "Register a new account"
  When I fill in "user_name" with "aaaa"
  When I fill in "user_email" with "1155123456@link.cuhk.edu.hk"
  When I select "Chung Chi College" from "user_location"
  When I fill in "password" with "aaaa"
  When I fill in "password_confirmation" with "bbbb"
  When I press "Register"
  Then I should see "Password confirmation doesn't match Password"
  Then I should see "Password is too short"

Scenario: invalid email

  Given I am on the home page
  When I follow "Register a new account"
  When I fill in "user_name" with "aaaa"
  When I fill in "user_email" with "my_email@gmail.com"
  When I select "Chung Chi College" from "user_location"
  When I fill in "password" with "aaaaaa"
  When I fill in "password_confirmation" with "aaaaaa"
  When I press "Register"
  Then I should see "Email must end with @link.cuhk.edu.hk"

Scenario: repeated registration

  Given I am on the home page
	When I registered account "aaa" with email name "1155111111", password "111111"
  When I follow "Register a new account"
  When I fill in "user_name" with "aaa"
  When I fill in "user_email" with "1155111111@link.cuhk.edu.hk"
  When I select "Chung Chi College" from "user_location"
  When I fill in "password" with "aaaaaa"
  When I fill in "password_confirmation" with "aaaaaa"
  When I press "Register"
  Then I should see "Name has already been taken"
  Then I should see "Email has already been taken"
  