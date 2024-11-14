Feature: Main landing page

  Scenario: Visiting the landing page as a guest
    Given I am on the login page
    Then I should see "Arcade"
    Then I should see "Created with ❤️ by CSCE 606 Team Arcade"
    When I press "Login as guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Letter Boxed"
    And I should see "2048"

  Scenario: Visiting the landing page as a logged in user
    Given I am on the login page
    Then I should see "Arcade"
    Then I should see "Created with ❤️ by CSCE 606 Team Arcade"
    And I should see "Login via SSO"
    When I login as System Admin
    Then I should see "Howdy Test!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Letter Boxed"
    And I should see "2048"