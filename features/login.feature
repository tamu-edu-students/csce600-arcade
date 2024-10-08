Feature: Login and Account Creation

Scenario: access Arcade as a  guest user
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Continue as Guest"
    Then I should see "Welcome, Guest!"
    And I should not see "You are logged in as"
    And I should not see "My Account"
    And I should see "Games"
    When I press "Play"
    Then I should see "Spelling Bee"

Scenario: login to arcade with Google
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    And I should see "Login with Google"
    When I login as System Admin
    Then I should see "Howdy Spongebob!"
    And I should see "You are logged in as System Admin"
    And I should see "All User"
    And I should see "My Account"
    And I should see "Games"
