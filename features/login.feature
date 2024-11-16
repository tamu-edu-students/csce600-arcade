Feature: Login and Account Creation

Scenario: access Arcade as a  guest user
    Given I am on the login page
    Then I should see "Arcade"
    Then I should see "Created with ❤️ by CSCE 606 Team Arcade"
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should not see "You are logged in as"
    And I should not see "My Account"
    And I should see "Games"
    When I press "Play"
    Then I should see "Spelling Bee"

Scenario: login to arcade with Google
    Given I am on the login page
    Then I should see "Arcade"
    Then I should see "Created with ❤️ by CSCE 606 Team Arcade"
    And I should see "Login via SSO"
    When I login as System Admin
    Then I should see "Howdy Test!"
    And I should see "Games"
