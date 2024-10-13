Feature: Wordle Game Page

  Scenario: Visiting wordle game page
    Given I am on the login page
    Then I should see "Welcome to CSCE 606 Team Arcade's Project"
    When I press "Continue as Guest"
    Then I should see "Welcome, Guest!"
    And I should see a list of games
    And I should see "Spelling Bee"
    And I should see "Wordle"
    And I should see "Play"
    When I click the Play button for "Wordle"
    Then I should see "Wordle"
    And I should see "How to play"
    And I should see "Play"
