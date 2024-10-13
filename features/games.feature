Feature: Main landing page

  Scenario: Visiting the landing page as a guest
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Continue as Guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Play"

  Scenario: Visiting the landing page as a logged in user
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    And I should see "Login with Google"
    When I login as System Admin
    Then I should see "Howdy Spongebob!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"